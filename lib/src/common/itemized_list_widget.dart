import 'package:flutter/material.dart';

typedef ItemizedListListener<T> = Function(T item);
typedef ItemWidgetBuilder<T> = Widget Function(T item, T? selectedItem);

class ItemizedListWidget<T> extends StatelessWidget {

  final ItemizedListListener<T> _itemListener;
  final ItemWidgetBuilder<T> _itemWidgetBuilder;
  final Iterable<T> _items;
  final T? _selectedItem;

  const ItemizedListWidget({super.key, required ItemizedListListener<T> itemListener,
    required ItemWidgetBuilder<T> itemWidgetBuilder,
    required Iterable<T> items, T? selectedItem}) :
        _itemListener = itemListener,
        _itemWidgetBuilder = itemWidgetBuilder,
        _items = items,
        _selectedItem = selectedItem;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          var item = _items.elementAt(index);
          var child = _itemWidgetBuilder(item, _selectedItem);
          return GestureDetector(
            key: child.key,
            child: child,
            onTap: () =>
                _itemListener(
                    item
                ),
          );
        }
    );
  }
}