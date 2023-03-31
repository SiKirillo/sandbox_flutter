import 'package:dartz/dartz.dart';

import '../../../../common/models/service/failure_model.dart';
import '../../../../common/models/service/usecase_model.dart';
import '../../../../common/services/logger_service.dart';
import '../../../../common/services/network_listener_service.dart';
import '../../../../common/usecases/core_update_in_app_failure.dart';
import '../bloc/auth_bloc.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/sign_up_model.dart';

class AuthSignUp implements UseCase<Either<Failure, void>, SignUpData> {
  final NetworkListenerService networkListenerService;
  final AuthBloc authBloc;
  final AuthRemoteDataSource authRemoteDataSource;
  final CoreUpdateInAppFailure coreUpdateInAppFailure;

  const AuthSignUp({
    required this.networkListenerService,
    required this.authBloc,
    required this.authRemoteDataSource,
    required this.coreUpdateInAppFailure,
  });

  @override
  Future<Either<Failure, void>> call(SignUpData data) async {
    LoggerService.logDebug('AuthSignUp -> call()');
    if (!await networkListenerService.checkNetworkConnection(() => call(data))) {
      return const Left(NetworkFailure());
    }

    final response = await authRemoteDataSource.signUp(data);
    return response.fold(
      (failure) {
        LoggerService.logDebug('FAILURE: AuthSignUp: authRemoteDataSource.signUp()');
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
