import 'package:authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'app_event.dart';
part 'app_state.dart';
part 'app_bloc.freezed.dart';

@singleton
class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(this.authentication) : super(const Initialized()) {
    on<CheckAuthentication>((event, emit) async {
      if (authentication.getUser() != null) {
        emit(const Authenticated());
      } else {
        emit(const Unauthenticated());
      }
    });

    on<_Unauthenticate>((event, emit) async {
      await authentication.signOut();

      emit(const Unauthenticated());
    });
  }

  final Authentication authentication;
}
