import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';

import '../blocs/app/app_bloc.dart';
import '../blocs/login/login_bloc.dart';
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
      drawer: AppDrawer(
        appBloc: getIt<AppBloc>(),
        authentication: getIt<Authentication>(),
        loginBloc: getIt<LoginBloc>(),
      ),
      body: const Center(
        child: Text('Your profile!'),
      ),
    );
  }
}
