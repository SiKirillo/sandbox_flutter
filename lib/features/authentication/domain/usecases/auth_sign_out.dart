import '../../../../common/models/service/usecase_model.dart';
import '../../../../common/services/logger_service.dart';
import '../bloc/auth_bloc.dart';
import '../datasources/auth_secure_storage.dart';

class AuthSignOut implements UseCase<void, NoParams> {
  final AuthBloc authBloc;
  final AuthSecureStorage authSecureStorage;

  const AuthSignOut({
    required this.authBloc,
    required this.authSecureStorage,
  });

  @override
  Future<void> call(NoParams params) async {
    LoggerService.logDebug('AuthSignOut -> call()');
    authBloc.add(SignOutAuthEvent());
    authSecureStorage.deleteTokensData();
  }
}
