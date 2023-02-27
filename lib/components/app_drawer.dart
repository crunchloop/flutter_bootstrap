import 'package:auth/auth.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../app_router.dart';

// statefull app drawer
class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  void signOut(BuildContext context) async {
    await Auth.signOut();
    context.router.push(const LoginRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green
            ),
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
            title: const Text('Sign Out'),
            onTap: () => signOut(context)
          ),
        ],
      ),
    );
  }
}
