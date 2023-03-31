import '../providers/theme_provider.dart';
import '../bloc/core_bloc.dart';
import '../models/service/shared_preferences_datasource_model.dart';
import '../services/logger_service.dart';

class CorePreferencesStorage extends AbstractSharedPreferencesDatasource {
  CorePreferencesStorage() : super(id: 'core');

  Future<bool> readAppRunConfigurationValue() async {
    LoggerService.logDebug('CorePreferencesStorage -> readAppRunConfigurationValue()');
    return (await CorePreferencesStorage().read('is_ran_before')) ?? false;
  }

  Future<void> writeAppRunConfigurationValue(bool isRanBefore) async {
    LoggerService.logDebug('CorePreferencesStorage -> writeAppRunConfigurationValue()');
    await CorePreferencesStorage().write('is_ran_before', isRanBefore);
  }

  Future<CoreSettingsData> readCoreSettings() async {
    LoggerService.logDebug('CorePreferencesStorage -> readCoreSettings()');
    final themeTypeIndex = await CorePreferencesStorage().read('enabled_theme_type');
    final isCharlesProxyEnabled = await CorePreferencesStorage().read('is_charles_proxy_enabled');

    return CoreSettingsData(
      themeType: themeTypeIndex is int ? ThemeStyleType.values[themeTypeIndex] : null,
      isCharlesProxyEnabled: isCharlesProxyEnabled,
    );
  }

  Future<void> writeCoreSettings(CoreSettingsData settings) async {
    LoggerService.logDebug('CorePreferencesStorage -> writeCoreSettings()');

    if (settings.themeType != null) {
      await CorePreferencesStorage().write('enabled_theme_type', settings.themeType?.index);
    }

    if (settings.isCharlesProxyEnabled != null) {
      await CorePreferencesStorage().write('is_charles_proxy_enabled', settings.isCharlesProxyEnabled);
    }
  }
}
