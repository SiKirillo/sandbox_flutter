part of '../../../common.dart';

class AppRepository {
  Future<void> init({bool isForced = false}) async {
    LoggerService.logTrace('AppRepository -> init(isForced: $isForced)');
    final isFirstLaunch = await locator<AppPreferencesStorage>().readInitialConfiguration();

    if (isFirstLaunch || isForced) {
      await Future.wait([
        AbstractSecureDatasource.deleteStorage(),
        AbstractSharedPreferencesDatasource.deletePreferences(),
        locator<AppPreferencesStorage>().writeInitialConfiguration(false),
      ]);
    }
  }

  Future<void> logout({bool isExpired = false}) async {
    LoggerService.logTrace('CommonRepository -> logout(isExpired: $isExpired)');
    locator<InAppOverlayProvider>().show(text: 'button.logout_processing'.tr());

    /// Clear token
    // await locator<PushNotificationService>().clearToken();
    // AbstractRemoteDatasource.tokenData = null;

    /// Re-init
    locator<AppRepository>().init(isForced: true);
    locator<AppBloc>().add(Reset_AppEvent(isSessionExpired: isExpired));

    locator<CameraBloc>().add(Reset_CameraEvent());
  }
}