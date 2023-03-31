import 'package:flutter_bloc/flutter_bloc.dart';

import '../providers/theme_provider.dart';
import '../models/in_app_failure_model.dart';
import '../models/in_app_notification_model.dart';
import '../models/in_app_toast_model.dart';
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
