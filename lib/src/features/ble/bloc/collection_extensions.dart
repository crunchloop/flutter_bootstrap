import 'package:built_collection/built_collection.dart';

extension RebuildableList<E> on List<E> {
  rebuild(Function(ListBuilder<E>) updates) => build().rebuild(updates).toList();
}

extension RebuildableMap<K, V> on Map<K, V> {
  rebuild(Function(MapBuilder<K, V>) updates) => build().rebuild(updates).toMap();
}