import 'package:flutter/material.dart';

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
          title: const Text("Device Selection"),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              const TabBar(tabs: [
                Tab(text: "Listen",),
              ]),
              Expanded(
                child: TabBarView(children: [
                  ListenLookup(onLookupFinished: _onLookupFinished),
                ])
              )
            ],
          )
        ),
      )
    );
  }

}