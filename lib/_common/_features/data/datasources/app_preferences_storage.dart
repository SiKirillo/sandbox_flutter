part of '../../../common.dart';

class AppPreferencesStorage extends AbstractSharedPreferencesDatasource {
  AppPreferencesStorage() : super(id: 'core');

  Future<bool> readInitialConfiguration() async {
    LoggerService.logTrace('AppPreferencesStorage -> readInitialConfiguration()');
    return (await AppPreferencesStorage().read('is_first_launch')) ?? true;
  }

  Future<void> writeInitialConfiguration(bool isFirstLaunch) async {
    LoggerService.logTrace('AppPreferencesStorage -> writeInitialConfiguration()');
    await AppPreferencesStorage().write('is_first_launch', isFirstLaunch);
  }

  Future<bool> readLocationWasRequestedOnStartApp() async {
    LoggerService.logTrace('AppPreferencesStorage -> readLocationWasRequestedOnStartApp()');
    return (await AppPreferencesStorage().read('location_was_requested_on_start_app')) ?? false;
  }

  Future<void> writeLocationWasRequestedOnStartApp() async {
    LoggerService.logTrace('AppPreferencesStorage -> writeLocationWasRequestedOnStartApp()');
    await AppPreferencesStorage().write('location_was_requested_on_start_app', true);
  }

  Future<Locale?> readLocale() async {
    LoggerService.logTrace('AppPreferencesStorage -> readLocale()');
    final languageCode = await AppPreferencesStorage().read('locale.language_code');
    final scriptCode = await AppPreferencesStorage().read('locale.script_code');
    if (languageCode == null || languageCode == '') {
      return null;
    }

    return Locale.fromSubtags(languageCode: languageCode, scriptCode: scriptCode);
  }

  Future<void> writeLocale(Locale locale) async {
    LoggerService.logTrace('AppPreferencesStorage -> writeLocale()');
    await AppPreferencesStorage().write('locale.language_code', locale.languageCode);
    await AppPreferencesStorage().write('locale.script_code', locale.scriptCode);
  }
}
