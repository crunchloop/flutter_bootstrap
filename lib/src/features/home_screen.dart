import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/src/components/component_storybook_screen.dart';
import 'package:flutter_bootstrap/src/components/custom_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
            child: Column(
          children: [
            Text(AppLocalizations.of(context).homeDescription),
            CustomButton(
              label: 'COMPONENT STORYBOOK',
              pressHandler: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ComponentStorybookScreen()));
              },
            )
          ],
        )),
      )),
    );
  }
}
