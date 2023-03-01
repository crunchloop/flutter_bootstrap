import 'package:flutter/material.dart';

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
        title: const Text('Profile'),
      ),
      drawer: AppDrawer(authBloc: getIt<AuthBloc>()),
      body: const Center(
        child: Text('Your profile!'),
      ),
    );
  }
}
