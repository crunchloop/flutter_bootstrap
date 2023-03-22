import 'dart:async';

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
  final AppBloc appBloc;
  final LoginBloc loginBloc;

  late final StreamSubscription<AppState> _stream;

  AuthGuard(this.appBloc, this.loginBloc) {
    _stream = appBloc.stream.listen((AppState state) {
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
      unauthenticated: (_) => router.push(
        LoginRoute(loginBloc: loginBloc),
      ),
    );
  }

  @override
  Future<bool> canNavigate(RouteMatch route) {
    return Future.value(appBloc.state is Authenticated);
  }
}

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: HomePage, initial: true, guards: [AuthGuard]),
    AutoRoute(page: ProfilePage),
    AutoRoute(page: LoginPage),
  ],
)
@Injectable()
class AppRouter extends _$AppRouter {
  AppRouter({required super.authGuard});
}
