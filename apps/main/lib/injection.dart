import 'package:authentication/authentication.dart';
import 'package:firebase_authentication/firebase_authentication.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_initialization/firebase_initialization.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
Future<void> configureDependencies() async => $initGetIt(getIt);

@module
abstract class RegisterModule {
  @singleton
  @preResolve
  Future<FirebaseApp> get initializeFirebase async {
    return await FirebaseInitialization.initialize();
  }

  Authentication get auth => FirebaseAuthentication.instance;
}
