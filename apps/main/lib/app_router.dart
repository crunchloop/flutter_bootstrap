import 'dart:async';

import 'package:authentication/authentication.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'blocs/app/app_bloc.dart';
import 'blocs/login/login_bloc.dart';
import 'pages/home.dart';
import 'pages/login.dart';
import 'pages/profile.dart';

part 'app_router.gr.dart';

@Injectable()
class AuthGuard extends AutoRedirectGuard {
  AuthGuard(this.appBloc, this.loginBloc, this.authentication) {
    _stream = loginBloc.stream.listen((state) {
      reevaluate();
    });
  }

  final LoginBloc loginBloc;
  final AppBloc appBloc;
  final Authentication authentication;

  late final StreamSubscription<LoginState> _stream;

  @override
  void dispose() {
    _stream.cancel();
    super.dispose();
  }

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    appBloc.state.maybeMap(
      orElse: () => resolver.next(false),
      initialized: (value) => resolver.next(),
      authenticated: (_) => resolver.next(),
      unauthenticated: (_) => router.replace(
        LoginRoute(
          loginBloc: loginBloc,
          authentication: authentication,
        ),
      ),
    );
  }

  @override
  Future<bool> canNavigate(RouteMatch route) =>
      Future.value(loginBloc.state is Succeeded);
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
      ],
    ),
  ],
)
@Injectable()
class AppRouter extends _$AppRouter {
  AppRouter({required super.authGuard});
}
