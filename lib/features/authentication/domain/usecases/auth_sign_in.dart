import 'package:dartz/dartz.dart';

import '../../../../common/models/service/failure_model.dart';
import '../../../../common/models/service/usecase_model.dart';
import '../../../../common/services/logger_service.dart';
import '../../../../common/services/network_listener_service.dart';
import '../bloc/auth_bloc.dart';
import '../models/sign_in_model.dart';
import '../services/auth_service.dart';

class AuthSignIn implements UseCase<Either<Failure, void>, SignInData> {
  final NetworkListenerService networkListenerService;
  final AuthBloc authBloc;
  final AuthService authService;

  const AuthSignIn({
    required this.networkListenerService,
    required this.authBloc,
    required this.authService,
  });

  @override
  Future<Either<Failure, void>> call(SignInData data) async {
    LoggerService.logDebug('AuthSignIn -> call()');
    if (!await networkListenerService.checkNetworkConnection(() => call(data))) {
      return const Left(NetworkFailure());
    }

    final response = await authService.signIn(data);
    return response.fold(
      (failure) {
        LoggerService.logDebug('FAILURE: AuthSignIn: authRemoteDataSource.signIn()');
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
