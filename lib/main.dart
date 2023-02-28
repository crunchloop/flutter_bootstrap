import 'package:flutter/material.dart';

import 'package:flutter_bootstrap/data/repositories/auth_facade.dart';

import 'injection.dart';
import 'app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();

  // TODO: use a guard to redirect to home if logged in
  final authFacade = AuthFacade();
  await authFacade.signOut();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
    );
  }
}
