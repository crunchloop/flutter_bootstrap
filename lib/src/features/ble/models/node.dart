import 'package:flutter_bootstrap/src/features/ble/bloc/collection_extensions.dart';
import 'package:flutter_bootstrap/src/features/ble/models/command_result.dart';
import 'package:flutter_bootstrap/src/features/ble/models/nta_command.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'atn_command.dart';

part 'node.freezed.dart';

@freezed
class Node with _$Node {

  static const service = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";
  static const rxCharacteristic = "6e400002-b5a3-f393-e0a9-e50e24dcca9e";
  static const txCharacteristic = "6e400003-b5a3-f393-e0a9-e50e24dcca9e";

  const Node._();

  const factory Node({
    required String id, required DiscoveredDevice device,
    required DateTime scanTime,
    @Default(DeviceConnectionState.disconnected) DeviceConnectionState connectionState,
    @Default([]) List<AtnCommand> pendingCommands,
    @Default([]) List<AtnCommand> executedCommands,
    @Default([]) List<CommandResult> commandResults}) = _Node;

  Node markFirstCommandExecution() {
    final command = pendingCommands.first;
    return copyWith(
        pendingCommands: pendingCommands.rebuild((b) => b..skip(1)),
        executedCommands: executedCommands.rebuild((b) => b..add(command))
    );
  }

  Node addResult(NtaCommand receivedCommand) {
    final sentCommandIndex = executedCommands.indexWhere(
      (element) => element.transactionId == receivedCommand.transactionId
    );

    final sentCommand = executedCommands[sentCommandIndex];

    if (sentCommandIndex > 0 && executedCommands[sentCommandIndex - 1] != commandResults.last.sent) {
      throw 'Invalid transaction for commands $sentCommand and $receivedCommand';
    }

    return copyWith(
        commandResults: commandResults.rebuild((b) => b..add(
            CommandResult(sent: sentCommand, received: receivedCommand))
        ),
    );
  }

  bool busy() => executedCommands.length < commandResults.length;

  bool needsConnection() => !(
      connectionState == DeviceConnectionState.connected ||
      connectionState == DeviceConnectionState.connecting
  );

  bool connected() => connectionState == DeviceConnectionState.connected;

  QualifiedCharacteristic get writeQualifiedCharacteristic => QualifiedCharacteristic(
      characteristicId: Node.rxCharacteristic.toBleUUID,
      serviceId: Node.service.toBleUUID,
      deviceId: id);

  QualifiedCharacteristic get readQualifiedCharacteristic => QualifiedCharacteristic(
      characteristicId: Node.txCharacteristic.toBleUUID,
      serviceId: Node.service.toBleUUID,
      deviceId: id);
}

extension ToBleUUID on String {
  Uuid get toBleUUID => Uuid.parse(this);
}