import 'package:dartz/dartz.dart';

import '../../../../common/models/service/failure_model.dart';
import '../../../../common/models/service/usecase_model.dart';
import '../../../../common/services/logger_service.dart';
import '../../../../common/services/network_listener_service.dart';
import '../../../../common/usecases/core_update_in_app_failure.dart';
import '../bloc/auth_bloc.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/sign_in_model.dart';

class AuthSignIn implements UseCase<Either<Failure, void>, SignInData> {
  final NetworkListenerService networkListenerService;
  final AuthBloc authBloc;
  final AuthRemoteDataSource authRemoteDataSource;
  final CoreUpdateInAppFailure coreUpdateInAppFailure;

  const AuthSignIn({
    required this.networkListenerService,
    required this.authBloc,
    required this.authRemoteDataSource,
    required this.coreUpdateInAppFailure,
  });

  @override
  Future<Either<Failure, void>> call(SignInData data) async {
    LoggerService.logDebug('AuthSignIn -> call()');
    if (!await networkListenerService.checkNetworkConnection(() => call(data))) {
      return const Left(NetworkFailure());
    }

    final response = await authRemoteDataSource.signIn(data);
    return response.fold(
      (failure) {
        LoggerService.logDebug('FAILURE: AuthSignIn: authRemoteDataSource.signIn()');
        LoggerService.logDebug('FAILURE: ${failure.message}');
        return Left(failure);
      },
      (result) {
        authBloc.add(UpdateAuthStatusEvent(authType: AuthStatusType.authenticated));
        return const Right(null);
      },
    );
  }
}
