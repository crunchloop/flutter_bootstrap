import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/src/app.dart';
import 'package:flutter_bootstrap/src/app_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = AppBlocObserver();
  runApp(const App());
}