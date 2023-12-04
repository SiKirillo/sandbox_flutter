import '../../../../common/models/service/secure_datasource.model.dart';
import '../../../../common/services/logger_service.dart';
import '../models/tokens_auth_model.dart';

class AuthSecureStorage extends AbstractSecureDatasource {
  AuthSecureStorage() : super(id: 'auth');

  Future<TokensAuthData?> readTokensData() async {
    LoggerService.logDebug('AuthSecureStorage -> readTokensData()');
    final accessToken = await AuthSecureStorage().read('tokens.${TokensAuthData.accessTokenKey}');
    final refreshToken = await AuthSecureStorage().read('tokens.${TokensAuthData.refreshTokenKey}');
    final expiresIn = await AuthSecureStorage().read('tokens.${TokensAuthData.expiresInKey}');

    if (accessToken != null && refreshToken != null && expiresIn != null) {
      return TokensAuthData(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresIn: int.tryParse(expiresIn) ?? 0,
      );
    }

    return null;
  }

  Future<void> writeTokensData(TokensAuthData data) async {
    LoggerService.logDebug('AuthSecureStorage -> writeTokensData()');
    await AuthSecureStorage().write('tokens.${TokensAuthData.accessTokenKey}', data.accessToken);
    await AuthSecureStorage().write('tokens.${TokensAuthData.refreshTokenKey}', data.refreshToken);
    await AuthSecureStorage().write('tokens.${TokensAuthData.expiresInKey}', data.expiresIn.toString());
  }

  Future<void> deleteTokensData() async {
    LoggerService.logDebug('AuthSecureStorage -> deleteTokensData()');
    await AuthSecureStorage().delete('tokens.${TokensAuthData.accessTokenKey}');
    await AuthSecureStorage().delete('tokens.${TokensAuthData.refreshTokenKey}');
    await AuthSecureStorage().delete('tokens.${TokensAuthData.expiresInKey}');
  }
}
