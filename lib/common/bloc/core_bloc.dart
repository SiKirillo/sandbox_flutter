import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/logger_service.dart';

part 'core_events.dart';
part 'core_state.dart';

class CoreBloc extends Bloc<CoreBlocEvent, CoreState> {
  CoreBloc(super.initialState) {
    on<SignOutCoreEvent>((event, emit) {
      emit(CoreState.initial());
    });
  }

  @override
  void onEvent(CoreBlocEvent event) {
    super.onEvent(event);
    LoggerService.logDebug('CoreBloc -> onEvent(): ${event.runtimeType}');
  }
}
