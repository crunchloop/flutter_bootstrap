import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:injectable/injectable.dart';

import '../data/repositories/auth.dart';
import '../injection.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

@singleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(const Initial()) {
    on<_Started>((event, emit) {
      // nothing here for now
    });

    on<_SignIn>((event, emit) async {
      emit(const Loading());

      await authRepository.signInWithEmailAndPassword(
          email: event.email, password: event.password);

      if (authRepository.getUser() != null) {
        emit(const Loaded());
      } else {
        emit(const Errored());
      }
    });

    on<_Logout>((event, emit) async {
      await authRepository.signOut();

      emit(const Initial());
    });

    @disposeMethod
    // ignore: unused_element
    void dispose() {
      close();
    }
  }
}
