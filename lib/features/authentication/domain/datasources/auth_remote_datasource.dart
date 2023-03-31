import 'package:dartz/dartz.dart';
import 'package:sandbox_flutter/features/authentication/domain/models/sign_in_model.dart';

import '../../../../common/models/service/failure_model.dart';
import '../../../../common/models/service/remote_datasource_model.dart';
import '../../../../common/services/logger_service.dart';
import '../models/sign_up_model.dart';

class AuthRemoteDataSource extends RemoteDatasource {
  Future<Either<Failure, SignInData>> signIn(SignInData data) async {
    LoggerService.logDebug('AuthRemoteDataSource -> signIn(email: ${data.email})');
    await Future.delayed(const Duration(seconds: 2));
    return Right(data);
  }

  Future<Either<Failure, SignUpData>> signUp(SignUpData data) async {
    LoggerService.logDebug('AuthRemoteDataSource -> signUp(email: ${data.email})');
    await Future.delayed(const Duration(seconds: 2));
    return Right(data);
  }
}
