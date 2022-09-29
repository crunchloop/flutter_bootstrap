import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import '../../../models/node.dart';
import 'bloc.dart';
import 'dart:developer' as developer;

class ListenBleBloc extends Bloc<ListenBleEvent, ListenBleState> {
  final CompositeSubscription _subscription = CompositeSubscription();
  static const nodeName = "Neural_Node";
  static const oldNodeTimeout = Duration(seconds: 3);

  final FlutterReactiveBle _bleManager;
  PermissionStatus _locationPermissionStatus = PermissionStatus.restricted;
  Timer? _oldNodesCheckTimer;

  ListenBleBloc() : _bleManager = FlutterReactiveBle(), super(const Uninitialized()) {
    on<StartDiscovery>(_startDiscovery);
    on<NodeDiscovered>(_nodeDiscovered);
    on<CheckOldNodes>(_checkOldNodes);
    on<SelectAll>(_selectAll);
    on<Toggle>(_toggleNode);
    add(const StartDiscovery());
    _oldNodesCheckTimer = Timer.periodic(oldNodeTimeout, (timer) {
      add(const CheckOldNodes());
    });
  }

  void _startDiscovery(StartDiscovery event, Emitter<ListenBleState> emit) async {
    if (state is! Uninitialized) {
      return;
    }
    developer.log("Created client");
    await _checkPermissions();
    developer.log("Checked permissions");
    await _waitForBluetoothPoweredOn();
    developer.log("Bluetooth powered on");
    _subscription.clear();
    developer.log("Canceled old subscription");

    emit(const ListenBleState());

    final subscription = _bleManager.scanForDevices(
        withServices: [Node.service.toBleUUID]
    ).map((device) {
      developer.log("on scan $device");
      if (!_isValidAdvertisementData(device)) {
        return null;
      }

      developer.log("on scan device ${device.manufacturerData}");

      return Node(device: device, id: device.id, scanTime: DateTime.now());
    }).whereType<Node>().listen((node) {
      add(NodeDiscovered(node));
    }, onError: (error) => onError(error, StackTrace.current));

    _subscription.add(subscription);
  }

  void _nodeDiscovered(NodeDiscovered event, Emitter<ListenBleState> emit) async {
    developer.log("Node found ${event.node}");
    emit(state.copyWithNewDevice(event.node));
  }

  void _checkOldNodes(CheckOldNodes event, Emitter<ListenBleState> emit) async {
    emit(state.copyRemovingDevicesByTime(oldNodeTimeout));
  }

  void _selectAll(SelectAll _, Emitter<ListenBleState> emit) {
    emit(state.copyWith(selectedNodes: state.nodes));
  }

  void _toggleNode(Toggle toggle, Emitter<ListenBleState> emit) {
    emit(state.copyWithToggleInNode(toggle.node));
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    _bleManager.deinitialize();
    developer.log('$error, $stackTrace');
  }

  bool _isValidAdvertisementData(DiscoveredDevice advertisementData) {
    return advertisementData.name == nodeName;
  }

  Future<void> _checkPermissions() async {
    if (Platform.isAndroid) {
      _locationPermissionStatus = await Permission.location.request();

      if (_locationPermissionStatus != PermissionStatus.granted) {
        return Future.error(Exception("Location permission not granted"));
      }
    }
  }

  Future<void> _waitForBluetoothPoweredOn() async {
    developer.log("subscribing to powered on event");
    return Rx.retry(() => _bleManager
      .statusStream
      .where((bluetoothState) {
        developer.log("powered on event $bluetoothState");
        return bluetoothState == BleStatus.ready;
      })
      .take(1)
      .timeout(const Duration(seconds: 5)), 3).listen((event) { })
      .asFuture();
  }

  @override
  Future<void> close() async {
    _oldNodesCheckTimer?.cancel();
    await _subscription.clear();
    await _bleManager.deinitialize();
    await super.close();
  }
}
