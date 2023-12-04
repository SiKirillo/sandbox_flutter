import 'package:get_it/get_it.dart';
import 'package:sandbox_flutter/features/authentication/domain/services/auth_service.dart';

import 'common/bloc/core_bloc.dart';
import 'common/datasources/core_preferences_storage.dart';
import 'common/providers/charles_provider.dart';
import 'common/providers/network_provider.dart';
import 'common/services/device_service.dart';
import 'common/services/firebase_service.dart';
import 'common/services/logger_service.dart';
import 'common/services/network_listener_service.dart';
import 'common/usecases/core_init.dart';
import 'common/usecases/core_update_settings.dart';
import 'common/providers/theme_provider.dart';
import 'features/authentication/domain/bloc/auth_bloc.dart';
import 'features/authentication/domain/usecases/auth_auto_sign_in.dart';
import 'features/authentication/domain/usecases/auth_init.dart';
import 'features/authentication/domain/usecases/auth_sign_in.dart';
import 'features/authentication/domain/usecases/auth_sign_up.dart';
import 'features/authentication/domain/usecases/auth_update_status.dart';

final locator = GetIt.instance;

void initLocator() {
  _initCore();
  _initAuth();
}

void _initCore() {
  /// Blocs
  locator.registerLazySingleton(
    () => CoreBloc(
      CoreState.initial(),
    ),
  );

  /// Providers
  locator.registerLazySingleton(
    () => ThemeProvider(),
  );
  locator.registerLazySingleton(
    () => NetworkProvider(),
  );
  locator.registerLazySingleton(
    () => CharlesProvider(),
  );

  /// Datasources
  locator.registerLazySingleton(
    () => CorePreferencesStorage(),
  );

  /// Services
  locator.registerLazySingleton(
    () => FirebaseService(),
  );
  locator.registerLazySingleton(
    () => DeviceService(),
  );
  locator.registerLazySingleton(
    () => LoggerService(),
  );
  locator.registerLazySingleton(
    () => NetworkListenerService(),
  );

  /// Usecases
  locator.registerLazySingleton(
    () => CoreInit(
      coreBloc: locator<CoreBloc>(),
      corePreferencesStorage: locator<CorePreferencesStorage>(),
      themeProvider: locator<ThemeProvider>(),
      charlesProvider: locator<CharlesProvider>(),
    ),
  );
  locator.registerLazySingleton(
    () => CoreUpdateSettings(
      coreBloc: locator<CoreBloc>(),
      corePreferencesStorage: locator<CorePreferencesStorage>(),
      themeProvider: locator<ThemeProvider>(),
      networkProvider: locator<NetworkProvider>(),
      charlesProvider: locator<CharlesProvider>(),
    ),
  );
}

void _initAuth() {
  /// Blocs
  locator.registerLazySingleton(
    () => AuthBloc(
      AuthState.initial(),
    ),
  );

  /// Services
  locator.registerLazySingleton(
    () => AuthService(),
  );

  /// Usecases
  locator.registerLazySingleton(
    () => AuthAutoSignIn(
      networkListenerService: locator<NetworkListenerService>(),
      authBloc: locator<AuthBloc>(),
    ),
  );
  locator.registerLazySingleton(
    () => AuthSignIn(
      networkListenerService: locator<NetworkListenerService>(),
      authBloc: locator<AuthBloc>(),
      authService: locator<AuthService>(),
    ),
  );
  locator.registerLazySingleton(
    () => AuthSignUp(
      networkListenerService: locator<NetworkListenerService>(),
      authBloc: locator<AuthBloc>(),
      authService: locator<AuthService>(),
    ),
  );
  locator.registerLazySingleton(
    () => AuthUpdateStatus(
      authBloc: locator<AuthBloc>(),
    ),
  );
  locator.registerLazySingleton(
    () => AuthInit(
      networkListenerService: locator<NetworkListenerService>(),
    ),
  );
}
