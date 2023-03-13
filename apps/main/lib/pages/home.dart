import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/bloc/auth_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/app_drawer.dart';
import '../injection.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: Text(message),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK')),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: AppDrawer(authBloc: getIt<AuthBloc>()),
      body: Center(
          child: ElevatedButton(
        onPressed: () {
          showAlert(AppLocalizations.of(context)!.homeScreenMessage);
        },
        child: Text(AppLocalizations.of(context)!.homeScreenButton),
      )),
    );
  }
}
