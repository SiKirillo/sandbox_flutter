import 'package:dartz/dartz.dart';
import 'package:sandbox_flutter/features/authentication/domain/services/auth_service.dart';

import '../../../../common/models/service/failure_model.dart';
import '../../../../common/models/service/usecase_model.dart';
import '../../../../common/services/logger_service.dart';
import '../../../../common/services/network_listener_service.dart';
import '../bloc/auth_bloc.dart';
import '../models/sign_up_model.dart';

class AuthSignUp implements UseCase<Either<Failure, void>, SignUpData> {
  final NetworkListenerService networkListenerService;
  final AuthBloc authBloc;
  final AuthService authService;

  const AuthSignUp({
    required this.networkListenerService,
    required this.authBloc,
    required this.authService,
  });

  @override
  Future<Either<Failure, void>> call(SignUpData data) async {
    LoggerService.logDebug('AuthSignUp -> call()');
    if (!await networkListenerService.checkNetworkConnection(() => call(data))) {
      return const Left(NetworkFailure());
    }

    final response = await authService.signUp(data);
    return response.fold(
      (failure) {
        LoggerService.logDebug('FAILURE: AuthSignUp: authRemoteDataSource.signUp()');
        LoggerService.logDebug('FAILURE: ${failure.message}');
        return Left(failure);
      },
      (result) {
        authBloc.add(SignInEvent(userData: result));
        return const Right(null);
      },
    );
  }
}
