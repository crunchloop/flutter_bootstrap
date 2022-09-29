import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bootstrap/src/common/sizes.dart';

import '../../../../common/itemized_list_widget.dart';
import '../../models/node.dart';
import 'bloc/bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListenLookup extends StatelessWidget {

  final Function(List<Node> devices) _onLookupFinished;

  const ListenLookup({super.key, required Function(List<Node> devices) onLookupFinished}) :
      _onLookupFinished = onLookupFinished;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListenBleBloc, ListenBleState>(
      builder: (context, state) =>
        Column(children: [
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: Sizes.small),
            child: ElevatedButton(
              child: Text(AppLocalizations.of(context).selectAll),
              onPressed: () => BlocProvider.of<ListenBleBloc>(context)
                  .add(const SelectAll()),
            ),
          ),
          Expanded(child: ItemizedListWidget<Node>(
              items: state.nodes,
              itemWidgetBuilder: (item, selectedItem) =>
                  Padding(
                    key: Key(item.id),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${item.device.name}:${item.id}"),
                        Checkbox(
                          value: state.isSelected(item),
                          onChanged: (value) => BlocProvider.of<ListenBleBloc>(context)
                            .add(Toggle(item)),
                        )
                      ],
                    ),
                  ),
              itemListener: (item) => _onLookupFinished([item]),
            )
          ),
          ElevatedButton(
              onPressed: () => _onLookupFinished(state.nodes),
              child: Text(AppLocalizations.of(context).routineTest)
          ),
        ],)
    );
  }

}