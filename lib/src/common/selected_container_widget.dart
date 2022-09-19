import 'package:flutter/material.dart';

class SelectedContainerWidget extends StatelessWidget {

  final bool _selected;
  final Widget _child;

  const SelectedContainerWidget({super.key, bool selected = false, required Widget child}) :
        _child = child,
        _selected = selected;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: _selected ?
          BoxDecoration(border: Border.all(color: Theme.of(context).primaryColor, width: 2)) : const BoxDecoration(),
        child: _child
    );
  }

}