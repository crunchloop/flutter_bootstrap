import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/auth_bloc.dart';
import '../app_router.dart';

class AppDrawer extends StatefulWidget {
  final AuthBloc _authBloc;

  const AppDrawer({Key? key, required AuthBloc authBloc})
      : _authBloc = authBloc,
        super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  void signOut(BuildContext context) {
    widget._authBloc.add(const AuthEvent.logout());
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.green),
            child: Text(AppLocalizations.of(context)!.appTitle),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.home),
            onTap: () {
              context.router.push(const HomeRoute());
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.profile),
            onTap: () {
              context.router.push(const ProfileRoute());
            },
          ),
          ListTile(
              title: Text(AppLocalizations.of(context)!.signOut),
              onTap: () => signOut(context)),
        ],
      ),
    );
  }
}
