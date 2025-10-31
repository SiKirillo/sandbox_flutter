part of 'common.dart';

final locator = GetIt.instance;

void initLocator() {
  _initCommon();
}

void _initCommon() {
  /// Common
  locator.registerLazySingleton(
    () => AppBloc(AppState.initial()),
  );
  locator.registerLazySingleton(
    () => AppPreferencesStorage(),
  );
  locator.registerLazySingleton(
    () => AppRepository(),
  );

  /// Camera
  locator.registerLazySingleton(
    () => CameraBloc(),
  );
  locator.registerLazySingleton(
    () => CameraRepository(),
  );

  /// Providers
  locator.registerLazySingleton(
    () => ThemeProvider(),
  );
  locator.registerLazySingleton(
    () => NetworkProvider(),
  );

  /// Services
  locator.registerLazySingleton(
    () => BiometricService(),
  );
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
    () => LocaleProvider(),
  );
  locator.registerLazySingleton(
    () => LocationService(),
  );

  /// Widgets
  locator.registerLazySingleton(
    () => InAppNotificationProvider(),
  );
  locator.registerLazySingleton(
    () => InAppToastProvider(),
  );
  locator.registerLazySingleton(
    () => InAppSliderProvider(),
  );
  locator.registerLazySingleton(
    () => InAppDialogsProvider(),
  );
  locator.registerLazySingleton(
    () => InAppOverlayProvider(),
  );
  locator.registerLazySingleton(
    () => LoggerProvider(),
  );
}
