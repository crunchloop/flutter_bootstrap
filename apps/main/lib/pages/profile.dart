import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/auth_bloc.dart';
import '../components/app_drawer.dart';
import '../injection.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profile),
      ),
      drawer: AppDrawer(authBloc: getIt<AuthBloc>()),
      body: Center(
        child: Text(AppLocalizations.of(context)!.profile),
      ),
    );
  }
}
