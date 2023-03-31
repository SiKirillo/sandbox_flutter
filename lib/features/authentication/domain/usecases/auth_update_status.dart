import '../../../../common/models/service/usecase_model.dart';
import '../../../../common/services/logger_service.dart';
import '../bloc/auth_bloc.dart';

class AuthUpdateStatus implements UseCase<void, AuthStatusType> {
  final AuthBloc authBloc;

  const AuthUpdateStatus({
    required this.authBloc,
  });

  @override
  Future<void> call(AuthStatusType type) async {
    LoggerService.logDebug('AuthUpdateStatus -> call(type: $type)');
    authBloc.add(UpdateAuthStatusEvent(authType: type));
  }
}
