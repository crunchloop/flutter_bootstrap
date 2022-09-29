import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/node.dart';

part 'listen_ble_event.freezed.dart';

@freezed
class ListenBleEvent with _$ListenBleEvent {

  const factory ListenBleEvent.startDiscovery() = StartDiscovery;
  const factory ListenBleEvent.nodeDiscovered(Node node) = NodeDiscovered;
  const factory ListenBleEvent.checkOldNodes() = CheckOldNodes;
  const factory ListenBleEvent.selectAll() = SelectAll;
  const factory ListenBleEvent.toggle(Node node) = Toggle;
}
