import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';
import 'services/firebase_auth.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
Future<void> configureDependencies() async => await $initGetIt(getIt);

@module
abstract class AppModule {
  @preResolve
  Future<FirebaseAuthService> get authService => FirebaseAuthService.init();
}
