import 'package:dartz/dartz.dart';

import '../../../../common/models/service/failure_model.dart';
import '../../../../common/models/service/remote_datasource_model.dart';
import '../../../../common/services/logger_service.dart';
import '../models/tokens_auth_model.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource extends AbstractRemoteDatasource {
  Future<Either<Failure, TokensAuthData>> signIn(String email) async {
    LoggerService.logDebug('AuthRemoteDataSource -> signIn(email: $email)');
    return post<TokensAuthData>(
      requestURL: '/auth/signin',
      body: email,
      onResponse: (response) {
        final responseData = response.data as Map<String, dynamic>;
        return Right(TokensAuthData.fromJson(responseData['tokens']));
      },
    );
  }

  Future<Either<Failure, List<dynamic>>> getUserAttributes(String email) async {
    LoggerService.logDebug('AuthRemoteDataSource -> getUserAttributes(email: $email)');
    return get<List<dynamic>>(
      requestURL: '/auth/attributes/$email',
      onResponse: (response) {
        final responseData = response.data as List;
        final List<dynamic> userDataList = responseData
            .map((json) => UserData.fromJson(json))
            .toList();
        return Right(userDataList);
      },
    );
  }

  Future<Either<Failure, TokensAuthData>> updateAuthTokens() async {
    LoggerService.logDebug('AuthRemoteDataSource -> updateAuthTokens()');
    return get<TokensAuthData>(
      requestURL: '/auth/refresh-token',
      onResponse: (response) {
        final responseData = response.data as Map<String, dynamic>;
        return Right(TokensAuthData.fromJson(responseData));
      },
    );
  }
}
