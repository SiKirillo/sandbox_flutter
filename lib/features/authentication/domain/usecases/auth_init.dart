import 'package:dartz/dartz.dart';

import '../../../../common/models/service/failure_model.dart';
import '../../../../common/models/service/usecase_model.dart';
import '../../../../common/services/logger_service.dart';
import '../../../../common/services/network_listener_service.dart';

class AuthInit implements UseCase<Either<Failure, void>, NoParams> {
  final NetworkListenerService networkListenerService;

  const AuthInit({
    required this.networkListenerService,
  });

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    LoggerService.logDebug('AuthInit -> call()');
    if (!await networkListenerService.checkNetworkConnection(() => call(params))) {
      return const Left(NetworkFailure());
    }

    await Future.delayed(const Duration(seconds: 2));
    return const Right(null);
  }
}
