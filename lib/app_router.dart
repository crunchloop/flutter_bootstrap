import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import 'pages/login.dart';
import 'pages/home.dart';
import 'pages/profile.dart';

part 'app_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: LoginPage, initial: true),
    AutoRoute(page: HomePage),
    AutoRoute(page: ProfilePage),
  ],
)
// extend the generated private router
class AppRouter extends _$AppRouter {}
