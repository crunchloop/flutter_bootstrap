part of 'login_bloc.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState.initialized() = Initialized;

  const factory LoginState.loading() = Loading;

  const factory LoginState.succeeded() = Succeeded;

  const factory LoginState.failed() = Failed;
}
