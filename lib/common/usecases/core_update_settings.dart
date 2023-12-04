import '../bloc/core_bloc.dart';
import '../datasources/core_preferences_storage.dart';
import '../models/app_settings_model.dart';
import '../models/service/usecase_model.dart';
import '../providers/charles_provider.dart';
import '../providers/network_provider.dart';
import '../services/logger_service.dart';
import '../providers/theme_provider.dart';

class CoreUpdateSettings implements UseCase<void, AppSettingsData> {
  final CoreBloc coreBloc;
  final CorePreferencesStorage corePreferencesStorage;
  final ThemeProvider themeProvider;
  final NetworkProvider networkProvider;
  final CharlesProvider charlesProvider;

  const CoreUpdateSettings({
    required this.coreBloc,
    required this.corePreferencesStorage,
    required this.themeProvider,
    required this.networkProvider,
    required this.charlesProvider,
  });

  @override
  Future<void> call(AppSettingsData settings) async {
    LoggerService.logDebug('CoreUpdateSettings -> call(theme: ${settings.themeMode}, charles: ${settings.isCharlesProxyEnabled}, network: ${settings.isNetworkEnabled})');
    corePreferencesStorage.writeAppSettings(settings);

    if (settings.themeMode != null) {
      themeProvider.update(mode: settings.themeMode);
    }

    if (settings.isNetworkEnabled != null) {
      networkProvider.update(isConnected: settings.isNetworkEnabled);
    }

    if (settings.isCharlesProxyEnabled != null || settings.proxyIP != null) {
      charlesProvider.update(isEnabled: settings.isCharlesProxyEnabled, proxyIP: settings.proxyIP);
    }
  }
}
