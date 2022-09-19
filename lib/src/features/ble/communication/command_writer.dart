import 'package:flutter_bootstrap/src/features/ble/models/atn_command.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../models/node.dart';

class CommandWriter {

  static const service = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";
  static const rxCharacteristic = "6e400002-b5a3-f393-e0a9-e50e24dcca9e";

  final FlutterReactiveBle _ble;

  CommandWriter(FlutterReactiveBle ble): _ble = ble;

  Future<void> write(Node device, AtnCommand command) async {
    print("parsing commands");

    await _ble.writeCharacteristicWithResponse(
        QualifiedCharacteristic(
            characteristicId: Uuid.parse(rxCharacteristic),
            serviceId: Uuid.parse(service),
            deviceId: device.id
        ), value: command.data);
    print("command written: $command in characteristic");
  }
}