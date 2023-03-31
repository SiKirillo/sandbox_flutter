import '../bloc/core_bloc.dart';
import '../datasources/core_preferences_storage.dart';
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
    final settingsData = await corePreferencesStorage.readCoreSettings();
    themeProvider.update(settingsData.themeType ?? ThemeStyleType.light);
    charlesProvider.update(settingsData.isCharlesProxyEnabled ?? false);
  }
}
