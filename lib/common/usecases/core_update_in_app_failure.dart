import '../bloc/core_bloc.dart';
import '../models/in_app_failure_model.dart';
import '../models/service/usecase_model.dart';
import '../services/logger_service.dart';
import '../widgets/in_app_elements/in_app_failure.dart';

class CoreUpdateInAppFailure implements UseCase<void, InAppFailureData?> {
  final CoreBloc coreBloc;

  const CoreUpdateInAppFailure({
    required this.coreBloc,
  });

  @override
  Future<void> call(InAppFailureData? failure) async {
    LoggerService.logDebug('CoreUpdateInAppFailure -> call()');
    coreBloc.add(UpdateCoreInAppFailureEvent(data: failure));
    await Future.delayed(InAppFailureBackground.animationDuration);
  }
}
