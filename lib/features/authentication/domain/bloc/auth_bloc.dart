import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sandbox_flutter/features/authentication/domain/models/tokens_auth_model.dart';

import '../../../../common/services/logger_service.dart';
import '../models/user_model.dart';

part 'auth_events.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthBlocEvent, AuthState> {
  AuthBloc(super.initialState) {
    on<SignInEvent>((event, emit) {
      emit(state.copyWith(
        userData: event.userData,
        authStatusType: AuthStatusType.authenticated,
      ));
    });

    on<UpdateAuthStatusEvent>((event, emit) {
      emit(state.copyWith(authStatusType: event.authType));
    });

    on<UpdateTokensDataEvent>((event, emit) {
      emit(state.copyWith(tokensData: event.tokensData));
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
