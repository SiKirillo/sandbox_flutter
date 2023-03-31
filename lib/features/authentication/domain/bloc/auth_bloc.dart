import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/services/logger_service.dart';
import '../models/user_model.dart';

part 'auth_events.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthBlocEvent, AuthState> {
  AuthBloc(AuthState initialState) : super(initialState) {
    on<SignInEvent>((event, emit) {
      emit(state.update(
        userData: event.userData,
        authStatusType: AuthStatusType.authenticated,
      ));
    });

    on<UpdateAuthStatusEvent>((event, emit) {
      emit(state.update(authStatusType: event.authType));
    });

    on<SignOutAuthEvent>((event, emit) {
      emit(AuthState.initial());
    });
  }

  @override
  void onEvent(AuthBlocEvent event) {
    super.onEvent(event);
    LoggerService.logDebug('AuthBloc -> onEvent(): ${event.runtimeType}');
  }
}