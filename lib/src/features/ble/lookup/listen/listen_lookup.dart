import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          Expanded(child: ItemizedListWidget<Node>(
              items: state.devices,
              itemWidgetBuilder: (item, selectedItem) =>
                  Padding(
                    key: Key(item.id),
                    padding: const EdgeInsets.all(16),
                    child: Text(item.device.name),
                  ),
              itemListener: (item) => _onLookupFinished([item]),
            )
          ),
          ElevatedButton(
              onPressed: () => _onLookupFinished(state.devices),
              child: Text(AppLocalizations.of(context).all)
          ),
        ],)
    );
  }

}