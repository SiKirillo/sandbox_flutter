import '../bloc/core_bloc.dart';
import '../datasources/core_preferences_storage.dart';
import '../models/service/usecase_model.dart';
import '../providers/charles_provider.dart';
import '../providers/network_provider.dart';
import '../services/logger_service.dart';
import '../providers/theme_provider.dart';

class CoreUpdateSettings implements UseCase<void, CoreSettingsData> {
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
  Future<void> call(CoreSettingsData settings) async {
    LoggerService.logDebug('CoreUpdateSettings -> call(theme: ${settings.themeType}, charles: ${settings.isCharlesProxyEnabled}, network: ${settings.isNetworkEnabled})');
    corePreferencesStorage.writeCoreSettings(settings);

    if (settings.themeType != null) {
      themeProvider.update(settings.themeType!);
    }

    if (settings.isNetworkEnabled != null) {
      networkProvider.update(settings.isNetworkEnabled!);
    }

    if (settings.isCharlesProxyEnabled != null) {
      charlesProvider.update(settings.isCharlesProxyEnabled!);
    }
  }
}
