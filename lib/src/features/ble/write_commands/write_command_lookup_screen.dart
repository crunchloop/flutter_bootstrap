import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bootstrap/src/features/ble/write_commands/write_command_screen.dart';

import '../lookup/listen/bloc/bloc.dart';
import '../lookup/lookup_screen.dart';

class WriteCommandLookupScreen extends StatelessWidget {

  const WriteCommandLookupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListenBleBloc()..add(const StartDiscovery()),
      child: LookupScreen(onLookupFinished: (devices) =>
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => WriteCommandScreen(devices: devices)
          )
      )
    ),);
  }

}