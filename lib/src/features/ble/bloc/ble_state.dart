import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/atn_command.dart';
import '../models/node.dart';
import '../models/nta_command.dart';

part 'ble_state.freezed.dart';

@freezed
class BleState with _$BleState {

  const factory BleState({
    @Default({}) Map<String, Node> nodes,
    @Default([]) List<AtnCommand> commands,
    @Default([]) List<NtaCommand> nodeEvents
  }) = _BleState;
}
