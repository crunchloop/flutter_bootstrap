import 'package:authentication/authentication.dart';
import 'package:firebase_authentication/firebase_authentication.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
Future<void> configureDependencies() async => await $initGetIt(getIt);

@module
abstract class RegisterModule {
  @singleton
  @preResolve
  Future<Authentication> get auth => FirebaseAuthentication.initialize();
}
