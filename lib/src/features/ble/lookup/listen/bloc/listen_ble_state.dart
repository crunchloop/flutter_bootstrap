import 'package:built_collection/built_collection.dart';
import 'package:flutter_bootstrap/src/features/ble/bloc/collection_extensions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/node.dart';

part 'listen_ble_state.freezed.dart';

@freezed
class ListenBleState with _$ListenBleState {

  static _nodeIdEquality(node) => ((Node nodeB) => node.id == nodeB.id);

  const ListenBleState._();
  const factory ListenBleState({ @Default([]) List<Node> nodes, @Default([]) List<Node> selectedNodes }) = _ListenBleState;
  const factory ListenBleState.uninitialized({ @Default([]) List<Node> nodes, @Default([]) List<Node> selectedNodes }) = Uninitialized;

  ListenBleState copyWithNewDevice(Node newNode) {
    var index = nodes.indexWhere(_nodeIdEquality(newNode));

    final newNodes = nodes.build().rebuild((builder) {
      return index == -1 ? builder.add(newNode):
      builder.replaceRange(index, index + 1, [newNode]);
    }).toList();

    return copyWith(
      nodes: newNodes,
      selectedNodes: _filterSelectedNodes(selectedNodes, newNodes)
    );
  }

  ListenBleState copyRemovingDevicesByTime(Duration timeout) {
    final newDevices = nodes.where(
      (element) => element.scanTime.isAfter(DateTime.now().subtract(timeout))
    ).toList();

    return copyWith(
        nodes: newDevices,
        selectedNodes: _filterSelectedNodes(selectedNodes, newDevices)
    );
  }

  ListenBleState copyWithToggleInNode(Node node) {
    return copyWith(
        selectedNodes: selectedNodes.rebuild(
          (b) => isSelected(node) ? (b..add(node)) : b..remove(node)
        )
    );
  }

  bool isSelected(Node node) => selectedNodes.indexWhere(_nodeIdEquality(node)) != -1;

  static List<Node> _filterSelectedNodes(List<Node> selectedNodes, List<Node> nodes) {
    return selectedNodes
        .where((node) => nodes.any(_nodeIdEquality(node)))
        .toList();
  }
}
