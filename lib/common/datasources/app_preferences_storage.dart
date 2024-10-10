part of '../common.dart';

class AppPreferencesStorage extends AbstractSharedPreferencesDatasource {
  AppPreferencesStorage() : super(id: 'core');

  Future<bool> readAppRunConfigurationValue() async {
    LoggerService.logTrace('CorePreferencesStorage -> readAppRunConfigurationValue()');
    return (await AppPreferencesStorage().read('is_ran_before')) ?? false;
  }

  Future<void> writeAppRunConfigurationValue(bool isRanBefore) async {
    LoggerService.logTrace('CorePreferencesStorage -> writeAppRunConfigurationValue()');
    await AppPreferencesStorage().write('is_ran_before', isRanBefore);
  }
}
