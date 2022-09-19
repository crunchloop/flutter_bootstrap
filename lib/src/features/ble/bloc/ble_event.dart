import 'package:flutter_bootstrap/src/features/ble/models/atn_command.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ble_event.freezed.dart';

@freezed
class BleEvent with _$BleEvent {
  const factory BleEvent.connect(String nodeId) = ConnectEvent;
  const factory BleEvent.updateNode(ConnectionStateUpdate connectionStateUpdate) = UpdateNodeEvent;
  const factory BleEvent.updateNodeCharacteristicValue(CharacteristicValue characteristicValue) = UpdateNodeCharacteristicValueEvent;
  const factory BleEvent.addCommand(AtnCommand command, String nodeId) = AddCommandEvent;
  const factory BleEvent.removeCommand(AtnCommand command, String nodeId) = RemoveCommandEvent;
  const factory BleEvent.send(AtnCommand command, String nodeId) = SendEvent;
  const factory BleEvent.sendFirst(String nodeId) = SendFirstEvent;
  const factory BleEvent.start(String nodeId) = StartEvent;
  const factory BleEvent.stop(String nodeId) = StopEvent;
}