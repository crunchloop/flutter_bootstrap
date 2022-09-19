import 'package:flutter_bootstrap/src/features/ble/bloc/collection_extensions.dart';
import 'package:flutter_bootstrap/src/features/ble/models/command_result.dart';
import 'package:flutter_bootstrap/src/features/ble/models/nta_command.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:developer' as developer;

import 'atn_command.dart';

part 'node.freezed.dart';

@freezed
class Node with _$Node {
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
    final sentCommand = executedCommands.last;

    if (sentCommand.transactionId != receivedCommand.transactionId) {
      developer.log('Invalid transaction for commands $sentCommand and $receivedCommand');
      return this;
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
}