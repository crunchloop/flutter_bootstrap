import 'package:bloc/bloc.dart';
import 'package:flutter_bootstrap/src/features/ble/bloc/collection_extensions.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:rxdart/rxdart.dart';

import '../communication/command_writer.dart';
import '../models/node.dart';
import '../models/nta_command.dart';
import 'ble_event.dart';
import 'ble_state.dart';

typedef NodeSelectorById = Node? Function(String id);
typedef NodeMap = Future<dynamic> Function(Node node);

class BleBloc extends Bloc<BleEvent, BleState> {

  final FlutterReactiveBle _ble;
  final CompositeSubscription _subscription = CompositeSubscription();
  final CommandWriter _commandWriter;

  BleBloc({required FlutterReactiveBle ble, required List<Node> nodes}) :
        _ble = ble,
        _commandWriter = CommandWriter(ble),
        super(BleState(nodes: {}.cast<String, Node>().rebuild((b) => b..addEntries(nodes.map((node) => MapEntry(node.id, node)))))) {

    on<ConnectEvent>(_connect);
    on<UpdateNodeEvent>(_updateNode);
    on<UpdateNodeCharacteristicValueEvent>(_updateNodeCharacteristicValue);
    on<AddCommandEvent>(_addCommand);
    on<RemoveCommandEvent>(_removeCommand);
    on<SendEvent>(_send);
    on<SendFirstEvent>(_sendFirst);
    on<StartEvent>(_start);
    on<StopEvent>(_stop);
    _subscribeToNodes();
    _subscribeToNotifications();
  }

  void _connect(ConnectEvent connect, Emitter<BleState> emit) async {
    final node = await _withNodeId(connect.nodeId, state);
    if (node == null || !node.needsConnection()) return;

    _ble.connectToDevice(id: node.id).flatMap(
            (event) => _ble.subscribeToCharacteristic(node.readQualifiedCharacteristic)
    ).listen((event) {}).addTo(_subscription);
  }

  void _updateNode(UpdateNodeEvent updateNode, Emitter<BleState> emit) {
    emit(_updateStateNode(updateNode.connectionStateUpdate.deviceId, (node) => node.copyWith(
        connectionState: updateNode.connectionStateUpdate.connectionState
    )));

    if (updateNode.connectionStateUpdate.connectionState == DeviceConnectionState.connected) {
      add(BleEvent.sendFirst(updateNode.connectionStateUpdate.deviceId));
    }
  }

  void _updateNodeCharacteristicValue(UpdateNodeCharacteristicValueEvent updateNodeCharacteristicValue, Emitter<BleState> emit) {
    final deviceId = updateNodeCharacteristicValue.characteristicValue.characteristic.deviceId;
    final payload = updateNodeCharacteristicValue.characteristicValue.result.dematerialize();
    final command = NtaCommand.fromPayload(payload);

    emit(_updateStateNode(deviceId, (node) => node.addResult(command)));

    add(BleEvent.sendFirst(deviceId));
  }

  void _addCommand(AddCommandEvent addCommand, Emitter<BleState> emit) {
    emit(_updateStateNode(
        addCommand.nodeId,
            (node) => node.copyWith(
                pendingCommands: node.pendingCommands
                    .rebuild((b) => b..add(addCommand.command))
            )
    ));
  }

  void _removeCommand(RemoveCommandEvent removeCommand, Emitter<BleState> emit) {
    emit(_updateStateNode(
        removeCommand.nodeId,
            (node) => node.copyWith(
              pendingCommands: node.pendingCommands
                  .rebuild((b) => b..remove(removeCommand.command))
        )
    ));
  }

  void _send(SendEvent send, Emitter<BleState> emit) async {
    await _withNodeId(send.nodeId, state, (node) async {
      emit(_updateStateNode(
          node.id, (node) => node.copyWith(
              pendingCommands: node.pendingCommands.rebuild((
                  b) => b..insert(0, send.command))
          )
      ));

      if (node.connected()) {
        add(SendFirstEvent(node.id));
      } else {
        add(ConnectEvent(node.id));
      }
    });
  }

  void _sendFirst(SendFirstEvent send, Emitter<BleState> emit) async {
    await _withNodeId(send.nodeId, state, (node) async {
      if (node.pendingCommands.isEmpty) {
        return;
      }

      if (node.connected()) {
        if (node.busy()) return;

        final command = node.pendingCommands.first;

        emit(_updateStateNode(
            send.nodeId,
                (node) => node.markFirstCommandExecution()
        ));

        await _commandWriter.write(node, command);
      } else {
        add(ConnectEvent(node.id));
      }
    });
  }

  void _start(StartEvent start, Emitter<BleState> emit) {
    _sendFirst(SendFirstEvent(start.nodeId), emit);
  }

  void _stop(StopEvent stop, Emitter<BleState> emit) {}

  void _subscribeToNodes() {
    _ble.connectedDeviceStream.listen((event) {
      add(BleEvent.updateNode(event));
    })
        .addTo(_subscription);
  }

  void _subscribeToNotifications() {
    _ble.characteristicValueStream.listen((event) {
      add(BleEvent.updateNodeCharacteristicValue(event));
    })
        .addTo(_subscription);
  }

  BleState _updateStateNode(String id, Node Function(Node) update) => state.copyWith(
    nodes: state.nodes.rebuild((b) => b..updateValue(id, (value) => update(value)))
  );

  static NodeSelectorById _defaultNodeSelector(BleState state) => (id) => state.nodes[id];

  static Future<Node?> _withNodeId(String nodeId, BleState state, [NodeMap? map]) async {
    final node = _defaultNodeSelector(state)(nodeId);
    if (node != null) {
      return await map?.call(node) ?? node;
    }
    return null;
  }

  @override
  Future<void> close() async {
    await _subscription.clear();
    return super.close();
  }
}
