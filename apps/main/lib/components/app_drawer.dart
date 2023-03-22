import 'package:authentication/authentication.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/blocs/app/app_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../app_router.dart';
import '../blocs/login/login_bloc.dart';

class AppDrawer extends StatefulWidget {
  final AppBloc _appBloc;
  final LoginBloc _loginBloc;
  final Authentication _authentication;

  const AppDrawer(
      {Key? key,
      required AppBloc appBloc,
      required LoginBloc loginBloc,
      required Authentication authentication})
      : _appBloc = appBloc,
        _loginBloc = loginBloc,
        _authentication = authentication,
        super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  void signOut(BuildContext context) {
    widget._appBloc.add(const AppEvent.unauthenticate());

    context.router.push(
      LoginRoute(
        loginBloc: widget._loginBloc,
        authentication: widget._authentication,
      ),
    );
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
