import 'package:dartz/dartz.dart';

import '../../../../common/models/service/failure_model.dart';
import '../../../../common/models/service/usecase_model.dart';
import '../../../../common/services/logger_service.dart';
import '../bloc/auth_bloc.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_secure_storage.dart';
import '../models/tokens_auth_model.dart';

class AuthRefreshTokens implements UseCase<Either<Failure, void>, TokensAuthData?> {
  final AuthBloc authBloc;
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthSecureStorage authSecureStorage;

  const AuthRefreshTokens({
    required this.authBloc,
    required this.authRemoteDataSource,
    required this.authSecureStorage,
  });

  @override
  Future<Either<Failure, void>> call(TokensAuthData? tokensToRefresh) async {
    LoggerService.logDebug('AuthRefreshTokens -> call(tokensToRefresh: $tokensToRefresh)');
    if (tokensToRefresh != null) {
      authBloc.add(UpdateTokensDataEvent(tokensData: tokensToRefresh));
      authSecureStorage.writeTokensData(tokensToRefresh);
      return const Right(null);
    }

    final response = await authRemoteDataSource.updateAuthTokens();
    return response.fold(
      (failure) {
        LoggerService.logDebug('FAILURE: AuthRefreshTokens: authRemoteDataSource.updateAuthToken()');
        LoggerService.logDebug('FAILURE: ${failure.message}');
        return Left(failure);
      },
      (result) async {
        authBloc.add(UpdateTokensDataEvent(tokensData: result));
        authSecureStorage.writeTokensData(result);
        return const Right(null);
      },
    );
  }
}
