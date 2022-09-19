import 'package:flutter_bootstrap/src/features/ble/models/atn_command.dart';
import 'package:flutter_bootstrap/src/features/ble/models/nta_command.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'command_result.freezed.dart';

@freezed
class CommandResult with _$CommandResult {
  const factory CommandResult({
    required AtnCommand sent, required NtaCommand received
  }) = _CommandResult;
}