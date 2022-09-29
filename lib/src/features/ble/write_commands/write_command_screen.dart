import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bootstrap/src/features/ble/bloc/ble_event.dart';
import 'package:flutter_bootstrap/src/features/ble/models/atn_command.dart';
import 'package:flutter_bootstrap/src/features/ble/models/shape.dart';
import 'package:flutter_bootstrap/src/features/ble/models/timeout.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../bloc/bloc.dart';
import '../bloc/ble_state.dart';
import '../models/node.dart';

class WriteCommandScreen extends StatelessWidget {

  final List<Node> _devices;
  final FlutterReactiveBle _ble;

  WriteCommandScreen({super.key, required List<Node> devices}) :
        _devices= devices, _ble = FlutterReactiveBle();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Command Writer"),
      ),
      body: BlocProvider(
          create: (context) => BleBloc(ble: _ble, nodes: _devices),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(padding: const EdgeInsets.all(16), child: Text(_devices.toString())),
                  Padding(padding: const EdgeInsets.all(16),
                      child: Builder(builder: (context) => ElevatedButton(
                        onPressed: () {
                            final bloc = BlocProvider.of<BleBloc>(context);
                            for (final node in _devices) {
                              bloc..add(AddCommandEvent(AtnCommand.train(led: Led.on,
                                  shape: Shape.cross,
                                  color: Color.cyan,
                                  sensor: Sensor.hoverMax,
                                  timeout: Timeout.timeMs(
                                      const Duration(seconds: 30))),
                                  node.id))
                                ..add(AddCommandEvent(
                                  AtnCommand.train(led: Led.on,
                                      shape: Shape.cross,
                                      color: Color.cyan,
                                      sensor: Sensor.hoverMax,
                                      timeout: Timeout.timeMs(
                                          const Duration(seconds: 30))),
                                  node.id))
                                ..add(AddCommandEvent(
                                  AtnCommand.train(led: Led.flash,
                                      shape: Shape.leftArrowUp,
                                      color: Color.blue,
                                      sensor: Sensor.touch,
                                      timeout: Timeout.timeMs(
                                          const Duration(seconds: 30))),
                                  node.id))
                                ..add(AddCommandEvent(
                                  AtnCommand.train(led: Led.on,
                                      shape: Shape.rightArrowUp,
                                      color: Color.magenta,
                                      sensor: Sensor.hoverMin,
                                      timeout: Timeout.timeMs(
                                          const Duration(seconds: 30))),
                                  node.id))
                                ..add(AddCommandEvent(
                                  AtnCommand.train(led: Led.on,
                                      shape: Shape.letter('D'.codeUnitAt(0)),
                                      color: Color.yellow,
                                      sensor: Sensor.touch,
                                      timeout: Timeout.timeMs(
                                          const Duration(seconds: 40))),
                                  node.id))
                                ..add(AddCommandEvent(
                                  AtnCommand.train(led: Led.on,
                                      shape: Shape.rightArrowDown,
                                      color: Color.red,
                                      sensor: Sensor.touch,
                                      timeout: Timeout.timeMs(
                                          const Duration(seconds: 30))),
                                  node.id))
                                ..add(StartEvent(node.id));
                            }
                        },
                        child: const Text("Write"),
                      ))
                  ),
                  BlocBuilder<BleBloc, BleState>(
                    builder: (context, state) =>
                        const Padding(padding: EdgeInsets.all(16), child: Text(
                          "Processing"
                        )),
                  )
                ],
              )
            )
          )
      )
    );
  }

}