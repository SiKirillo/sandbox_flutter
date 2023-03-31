import '../bloc/core_bloc.dart';
import '../models/in_app_toast_model.dart';
import '../models/service/usecase_model.dart';
import '../services/logger_service.dart';

class CoreUpdateInAppToast implements UseCase<void, InAppToastData?> {
  final CoreBloc coreBloc;

  const CoreUpdateInAppToast({
    required this.coreBloc,
  });

  @override
  Future<void> call(InAppToastData? toast) async {
    if (toast?.id == coreBloc.state.infoToastData?.id) {
      return;
    }

    if (toast?.type == InAppToastType.network) {
      return;
    }

    LoggerService.logDebug('CoreUpdateInAppToast -> call(id: ${toast?.id}, key: ${toast?.key})');
    coreBloc.add(UpdateCoreInAppToastEvent(data: toast));
  }
}
