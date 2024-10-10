import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';

part 'auth_events.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthBlocEvent, AuthState> {
  AuthBloc(super.initialState) {
    on<UpdateAuthStateEvent>((event, emit) {
      emit(state.copyWith(stateEvent: event.stateEvent));
    });

    on<SignOutAuthEvent>((event, emit) {
      emit(AuthState.signOut());
    });
  }

  @override
  void onEvent(AuthBlocEvent event) {
    super.onEvent(event);
    LoggerService.logTrace('AuthBloc -> onEvent(): ${event.runtimeType}');
  }
}
