import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/in_app_failures/in_app_failure_provider.dart';
import '../services/in_app_notifications/in_app_notification_provider.dart';
import '../services/in_app_toast/in_app_toast_provider.dart';
import '../services/logger_service.dart';

part 'core_events.dart';
part 'core_state.dart';

class CoreBloc extends Bloc<CoreBlocEvent, CoreState> {
  CoreBloc(CoreState initialState) : super(initialState) {
    on<UpdateCoreInAppNotificationEvent>((event, emit) {
      emit(state.updateInAppNotification(data: event.data));
    });

    on<UpdateCoreInAppFailureEvent>((event, emit) {
      emit(state.updateInAppFailure(data: event.data));
    });

    on<UpdateCoreInAppToastEvent>((event, emit) {
      emit(state.updateInAppToast(data: event.data));
    });

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
