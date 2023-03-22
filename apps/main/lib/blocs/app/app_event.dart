part of 'app_bloc.dart';

@freezed
class AppEvent with _$AppEvent {
  const factory AppEvent.checkAuthentication() = CheckAuthentication;

  const factory AppEvent.unauthenticate() = _Unauthenticate;
}
