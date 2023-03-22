import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:injectable/injectable.dart';

import 'injection.dart';
import 'app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // fb.configureDependencies();
  await configureDependencies();

  // await FirebaseAuthentication.initialize();

  runApp(MyApp(appRouter: getIt<AppRouter>()));
}

@Injectable()
class MyApp extends StatelessWidget {
  final AppRouter _appRouter;

  const MyApp({Key? key, required AppRouter appRouter})
      : _appRouter = appRouter,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('es', ''),
      ],
    );
  }
}
