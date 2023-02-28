// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i6;
import 'package:flutter_bootstrap/data/repositories/auth_facade.dart' as _i3;
import 'package:flutter_bootstrap/pages/login.dart' as _i5;
import 'package:flutter_bootstrap/services/firebase_auth.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'injection.dart' as _i7;

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// initializes the registration of main-scope dependencies inside of GetIt
Future<_i1.GetIt> $initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final appModule = _$AppModule();
  gh.factory<_i3.AuthFacade>(() => _i3.AuthFacade());
  await gh.factoryAsync<_i4.FirebaseAuthService>(
    () => appModule.authService,
    preResolve: true,
  );
  gh.factory<_i5.LoginPage>(() => _i5.LoginPage(key: gh<_i6.Key>()));
  return getIt;
}

class _$AppModule extends _i7.AppModule {}
