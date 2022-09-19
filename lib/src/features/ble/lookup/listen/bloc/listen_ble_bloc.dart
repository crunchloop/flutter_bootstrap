import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import '../../../models/node.dart';
import 'bloc.dart';

class ListenBleBloc extends Bloc<ListenBleEvent, ListenBleState> {
  final CompositeSubscription _subscription = CompositeSubscription();

  final FlutterReactiveBle _bleManager;
  PermissionStatus _locationPermissionStatus = PermissionStatus.restricted;
  Timer? _oldNodesCheckTimer;

  ListenBleBloc() : _bleManager = FlutterReactiveBle(), super(const ListenBleState()) {
    on<StartDiscovery>(_startDiscovery);
    on<NodeDiscovered>(_nodeDiscovered);
    on<CheckOldNodes>(_checkOldNodes);
    add(const StartDiscovery());
    _oldNodesCheckTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      add(const CheckOldNodes());
    });
  }

  static const service = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";

  void _startDiscovery(StartDiscovery event, Emitter<ListenBleState> emit) async {
    if (state is! Uninitialized) {
      return;
    }
    print("Creating client");
    print("Created client");
    await _checkPermissions();
    print("Checked permissions");
    await _waitForBluetoothPoweredOn();
    print("Bluetooth powered on");
    _subscription.clear();
    print("Canceled old subscription");

    emit(ListenBleState.withDevices([]));

    final subscription = _bleManager.scanForDevices(withServices: [Uuid.parse(service)]).map((device) {
      print("on scan $device");
      if (!_isValidAdvertisementData(device)) {
        return null;
      }

      print("on scan device ${device.manufacturerData}");

      return Node(device: device, id: device.id, scanTime: DateTime.now());
    }).whereType<Node>().listen((device) {
      add(NodeDiscovered(device));
    }, onError: (error) => onError(error, StackTrace.current));

    _subscription.add(subscription);
  }

  void _nodeDiscovered(NodeDiscovered event, Emitter<ListenBleState> emit) async {
    final devices = state.devices;
    final node = event.node;

    var index = devices.indexWhere((element) => element.id == node.id);

    print("gt device found $node");
    emit(ListenBleState.withDevices(BuiltList.of(devices).
    rebuild((builder) {
      return index == -1 ? builder.add(node):
      builder.replaceRange(index, index + 1, [node]);
    })
        .toList())
    );
  }

  void _checkOldNodes(CheckOldNodes event, Emitter<ListenBleState> emit) async {
    emit(state.copyWith(devices: state.devices.where(
      (element) => element.scanTime.isAfter(DateTime.now().subtract(const Duration(seconds: 4)))
    ).toList()));
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    _bleManager?.deinitialize();
    print('$error, $stackTrace');
  }

  bool _isValidAdvertisementData(DiscoveredDevice advertisementData) {
    return advertisementData.name == "Neural_Node";
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
    print("subscribing to powered on event");
    return Rx.retry(() => _bleManager
      .statusStream
      .where((bluetoothState) {
        print("powered on event $bluetoothState");
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
