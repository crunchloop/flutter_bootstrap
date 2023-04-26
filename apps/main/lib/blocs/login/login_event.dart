part of 'login_bloc.dart';

@freezed
class LoginEvent with _$LoginEvent {
  const factory LoginEvent.start() = _Start;

  const factory LoginEvent.signIn({email, password}) = _SignIn;
}
