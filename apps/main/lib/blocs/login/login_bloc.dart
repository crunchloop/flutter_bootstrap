import 'package:authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bootstrap/blocs/app/app_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_bloc.freezed.dart';

@singleton
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AppBloc appBloc;
  final Authentication authentication;

  LoginBloc(this.authentication, this.appBloc) : super(const Initialized()) {
    on<_Start>((event, emit) async {
      appBloc.add(const AppEvent.checkAuthentication());
    });

    on<_SignIn>((event, emit) async {
      emit(const Loading());

      await authentication.signInWithEmailAndPassword(
          email: event.email, password: event.password);

      if (authentication.getUser() != null) {
        appBloc.add(const AppEvent.checkAuthentication());

        emit(const Succeeded());
      } else {
        emit(const Failed());
      }
    });
  }
}
