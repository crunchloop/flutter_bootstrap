import 'package:flutter_bootstrap/src/features/ble/models/atn_command.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'dart:developer' as developer;
import '../models/node.dart';

class CommandWriter {

  final FlutterReactiveBle _ble;

  CommandWriter(FlutterReactiveBle ble): _ble = ble;

  Future<void> write(Node node, AtnCommand command) async {
    developer.log("parsing commands");

    await _ble.writeCharacteristicWithResponse(
        node.writeQualifiedCharacteristic, value: command.data
    );
    developer.log("command written: $command in characteristic");
  }
}