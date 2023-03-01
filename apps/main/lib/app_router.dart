import 'dart:async';

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bootstrap/data/repositories/auth.dart';
import 'package:injectable/injectable.dart';

import 'bloc/auth_bloc.dart';
import 'pages/login.dart';
import 'pages/home.dart';
import 'pages/profile.dart';

part 'app_router.gr.dart';

@Injectable()
class AuthGuard extends AutoRedirectGuard {
  final AuthBloc authBloc;
  final AuthRepository authRepository;
  late final StreamSubscription<AuthState> _stream;

  AuthGuard(this.authBloc, this.authRepository) {
    _stream = authBloc.stream.listen((state) {
      state.maybeMap(
        orElse: () {
          reevaluate();
        },
        loaded: (_) {},
      );
    });
  }

  @override
  void dispose() {
    _stream.cancel();
    super.dispose();
  }

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    authBloc.state.maybeMap(
        orElse: () {
          if (authRepository.getUser() == null) {
            router.push(
                LoginRoute(authBloc: authBloc, authRepository: authRepository));
          } else {
            resolver.next(true);
          }
        },
        loading: (_) => {},
        loaded: (_) => resolver.next(true));
  }

  @override
  Future<bool> canNavigate(RouteMatch route) {
    return Future.value(authBloc.state is Loaded);
  }
}

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      initial: true,
      guards: [AuthGuard],
      page: HomePage,
    ),
    AutoRoute(
      page: LoginPage,
    ),
    AutoRoute(page: ProfilePage),
  ],
)
@Injectable()
class AppRouter extends _$AppRouter {
  AppRouter({required super.authGuard});
}
