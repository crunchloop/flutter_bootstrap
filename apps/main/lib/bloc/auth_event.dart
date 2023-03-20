part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.started() = _Started;

  const factory AuthEvent.signIn({email, password}) = _SignIn;

  const factory AuthEvent.logout() = _Logout;
}
