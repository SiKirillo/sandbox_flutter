import '../bloc/core_bloc.dart';
import '../models/in_app_notification_model.dart';
import '../models/service/usecase_model.dart';
import '../services/logger_service.dart';

class CoreUpdateInAppNotification implements UseCase<void, InAppNotificationData?> {
  final CoreBloc coreBloc;

  const CoreUpdateInAppNotification({
    required this.coreBloc,
  });

  @override
  Future<void> call(InAppNotificationData? notification) async {
    if (notification?.id == coreBloc.state.inAppNotificationData?.id) {
      return;
    }

    LoggerService.logDebug('CoreUpdateInAppNotification -> call(id: ${notification?.id})');
    if (notification == null) {
      coreBloc.add(UpdateCoreInAppNotificationEvent(data: coreBloc.state.inAppNotificationData?.empty()));
    } else {
      coreBloc.add(UpdateCoreInAppNotificationEvent(data: notification));
    }
  }
}
