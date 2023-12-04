import 'package:flutter/material.dart';

import '../bloc/core_bloc.dart';
import '../datasources/core_preferences_storage.dart';
import '../models/service/secure_datasource.model.dart';
import '../models/service/shared_preferences_datasource_model.dart';
import '../models/service/usecase_model.dart';
import '../providers/charles_provider.dart';
import '../services/logger_service.dart';
import '../providers/theme_provider.dart';

class CoreInit implements UseCase<void, NoParams> {
  final CoreBloc coreBloc;
  final CorePreferencesStorage corePreferencesStorage;
  final ThemeProvider themeProvider;
  final CharlesProvider charlesProvider;

  const CoreInit({
    required this.coreBloc,
    required this.corePreferencesStorage,
    required this.themeProvider,
    required this.charlesProvider,
  });

  @override
  Future<void> call(NoParams params) async {
    LoggerService.logDebug('CoreInit -> call()');
    final isRanBefore = await corePreferencesStorage.readAppRunConfigurationValue();
    if (!isRanBefore) {
      await AbstractSecureDatasource.deleteStorage();
      await AbstractSharedPreferencesDatasource.deletePreferences();
      await corePreferencesStorage.writeAppRunConfigurationValue(true);
    }

    final settingsData = await corePreferencesStorage.readAppSettings();
    themeProvider.init(
      mode: ThemeMode.system,
      brightness: WidgetsBinding.instance.platformDispatcher.platformBrightness,
    );
    charlesProvider.update(
      isEnabled: settingsData.isCharlesProxyEnabled,
      proxyIP: settingsData.proxyIP,
    );
  }
}
