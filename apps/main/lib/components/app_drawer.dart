import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

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
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              context.router.push(const HomeRoute());
            },
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () {
              context.router.push(const ProfileRoute());
            },
          ),
          ListTile(
              title: const Text('Sign Out'), onTap: () => signOut(context)),
        ],
      ),
    );
  }
}
