part of 'app_bloc.dart';

@freezed
class AppState with _$AppState {
  const factory AppState.initialized() = Initialized;

  const factory AppState.authenticated() = Authenticated;

  const factory AppState.unauthenticated() = Unauthenticated;
}
