import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/node.dart';
import 'listen/listen_lookup.dart';

class LookupScreen extends StatelessWidget {

  final Function(List<Node> devices) _onLookupFinished;

  const LookupScreen({ super.key,
    required Function(List<Node> devices) onLookupFinished,
  }) :
    _onLookupFinished = onLookupFinished;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).deviceSelection),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
                Expanded(
                child: ListenLookup(onLookupFinished: _onLookupFinished),
              ),
            ]
          )
        ),
      )
    );
  }

}