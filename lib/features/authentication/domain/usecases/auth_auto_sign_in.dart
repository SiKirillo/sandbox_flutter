import 'package:dartz/dartz.dart';

import '../../../../common/models/service/failure_model.dart';
import '../../../../common/models/service/usecase_model.dart';
import '../../../../common/services/logger_service.dart';
import '../../../../common/services/network_listener_service.dart';
import '../bloc/auth_bloc.dart';

class AuthAutoSignIn implements UseCase<Either<Failure, void>, NoParams> {
  final NetworkListenerService networkListenerService;
  final AuthBloc authBloc;

  const AuthAutoSignIn({
    required this.networkListenerService,
    required this.authBloc,
  });

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    LoggerService.logDebug('AuthAutoSignIn -> call()');
    if (!await networkListenerService.checkNetworkConnection(() => call(params))) {
      return const Left(NetworkFailure());
    }

    await Future.delayed(const Duration(seconds: 2));
    return const Right(null);
  }
}
