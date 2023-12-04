import 'package:flutter/material.dart';

import '../models/app_settings_model.dart';
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

  Future<AppSettingsData> readAppSettings() async {
    LoggerService.logDebug('CorePreferencesStorage -> readAppSettings()');
    final themeModeIndex = await CorePreferencesStorage().read('selected_theme_mode');
    final isCharlesProxyEnabled = await CorePreferencesStorage().read('is_charles_proxy_enabled');
    final proxyIP = await CorePreferencesStorage().read('proxy_ip');

    return AppSettingsData(
      themeMode: themeModeIndex is int ? ThemeMode.values[themeModeIndex] : null,
      isCharlesProxyEnabled: isCharlesProxyEnabled,
      proxyIP: proxyIP,
    );
  }

  Future<void> writeAppSettings(AppSettingsData settings) async {
    LoggerService.logDebug('CorePreferencesStorage -> writeCoreSettings()');
    if (settings.themeMode != null) {
      await CorePreferencesStorage().write('selected_theme_mode', settings.themeMode?.index);
    }

    if (settings.isCharlesProxyEnabled != null) {
      await CorePreferencesStorage().write('is_charles_proxy_enabled', settings.isCharlesProxyEnabled);
    }

    if (settings.proxyIP != null) {
      await CorePreferencesStorage().write('proxy_ip', settings.proxyIP);
    }
  }
}
