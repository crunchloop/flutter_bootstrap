import 'dart:async';

import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bootstrap/blocs/app/app_bloc.dart';
import 'package:injectable/injectable.dart';

import 'blocs/login/login_bloc.dart';
import 'pages/login.dart';
import 'pages/home.dart';
import 'pages/profile.dart';

part 'app_router.gr.dart';

@Injectable()
class AuthGuard extends AutoRedirectGuard {
  final LoginBloc loginBloc;
  final AppBloc appBloc;
  final Authentication authentication;

  late final StreamSubscription<LoginState> _stream;

  AuthGuard(this.appBloc, this.loginBloc, this.authentication) {
    _stream = loginBloc.stream.listen((LoginState state) {
      reevaluate();
    });
  }

  @override
  void dispose() {
    _stream.cancel();
    super.dispose();
  }

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    appBloc.state.maybeMap(
      orElse: () => resolver.next(false),
      initialized: (value) => resolver.next(true),
      authenticated: (_) => resolver.next(true),
      unauthenticated: (_) => router.replace(
          LoginRoute(loginBloc: loginBloc, authentication: authentication)),
    );
  }

  @override
  Future<bool> canNavigate(RouteMatch route) {
    return Future.value(loginBloc.state is Succeeded);
  }
}

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      page: LoginPage,
    ),
    AutoRoute(
        initial: true,
        guards: [AuthGuard],
        page: HomePage,
        children: [
          AutoRoute(page: ProfilePage),
        ]),
  ],
)
@Injectable()
class AppRouter extends _$AppRouter {
  AppRouter({required super.authGuard});
}
