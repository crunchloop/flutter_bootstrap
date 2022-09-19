import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/node.dart';

part 'listen_ble_state.freezed.dart';

@freezed
class ListenBleState with _$ListenBleState {

  const factory ListenBleState([@Default([]) List<Node> devices]) = Uninitialized;
  factory ListenBleState.withDevices(List<Node> devices) = WithDevices;
}
