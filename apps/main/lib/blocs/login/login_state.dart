part of 'login_bloc.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState.initial() = Initialized; // initialized

  const factory LoginState.loading() = Loading;

  const factory LoginState.succeeded() = Succeeded; // succedded

  const factory LoginState.errored() = Errored;
}
