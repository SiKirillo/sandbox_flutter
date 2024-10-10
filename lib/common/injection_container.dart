import 'package:get_it/get_it.dart';

import '../features/authentication/domain/bloc/auth_bloc.dart';
import 'common.dart';
import 'services/in_app_notifications/in_app_notification_provider.dart';
import 'services/in_app_slider/in_app_slider_provider.dart';
import 'services/in_app_toast/in_app_toast_provider.dart';

final locator = GetIt.instance;

void initLocator() {
  _initApp();
  _initAuth();
}

void _initApp() {
  /// Datasources
  locator.registerLazySingleton(
    () => AppPreferencesStorage(),
  );

  /// Providers
  locator.registerLazySingleton(
    () => ThemeProvider(),
  );
  locator.registerLazySingleton(
    () => InAppNotificationProvider(),
  );
  locator.registerLazySingleton(
    () => InAppSliderProvider(),
  );
  locator.registerLazySingleton(
    () => InAppToastProvider(),
  );

  /// Services
  locator.registerLazySingleton(
    () => DeviceService(),
  );
  locator.registerLazySingleton(
    () => LoggerService(),
  );
  locator.registerLazySingleton(
    () => PermissionService(),
  );
  locator.registerLazySingleton(
    () => SupabaseService(),
  );

  /// Usecases
  locator.registerLazySingleton(
    () => AppInit(
      appPreferencesStorage: locator(),
    ),
  );
}

void _initAuth() {
  /// Blocs
  locator.registerLazySingleton(
    () => AuthBloc(AuthState.initial()),
  );
}