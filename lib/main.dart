import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '_common/common.dart';
import '_common/services/logger/logger_service.dart';
import '_common/widgets/in_app/dialogs/in_app_dialogs_provider.dart';
import '_common/widgets/in_app/notifications/in_app_notification_provider.dart';
import '_common/widgets/in_app/overlay/in_app_overlay_provider.dart';
import '_common/widgets/in_app/slider/in_app_slider_provider.dart';
import '_common/widgets/in_app/toast/in_app_toast_provider.dart';
import 'features/camera/camera.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      await _init();
      runApp(
        EasyLocalization(
          supportedLocales: LocaleProvider.supportedLocales,
          startLocale: locator<LocaleProvider>().language.toLocale(),
          fallbackLocale: Locale('en'),
          assetLoader: RootBundleAssetLoader(),
          // assetLoader: MergedAssetLoader(),
          path: 'assets/translations',
          useOnlyLangCode: true,
          useFallbackTranslations: true,
          ignorePluralRules: false,
          child: FlutterApp(),
        ),
      );
    },
    (error, stacktrace) {
      LoggerService.logError('Uncaught app exception', exception: error, stackTrace: stacktrace);
      // FirebaseCrashlyticsService.recordError(error: error, stackTrace: stacktrace);
      locator<InAppOverlayProvider>().hide();
    },
  );
}

Future<void> _init() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  /// Init services
  initLocator();
  await Future.wait([
    locator<DeviceService>().init(),
    AbstractSharedPreferencesDatasource.init(),
  ]);

  /// Init logger
  LoggerService.init(isEnabled: locator<DeviceService>().getBuildMode() != BuildMode.release);
  Bloc.observer = LoggerService.talkerBloc;

  /// Init remote datasource
  await Future.wait([
    locator<NetworkProvider>().init(),
    AbstractRemoteDatasource.init(
      // onRefreshToken: () => locator<AuthRepository>().refreshToken(),
      // onExpiredToken: () => locator<AppRepository>().logout(isExpired: true),
    ),
  ]);

  // FirebaseMessagingService.registerBackgroundMessageHandler();

  /// Init Firebase
  // final firebase = await FirebaseCoreService.init(
  //   name: 'default',
  //   options: switch (locator<DeviceService>().getFlavorMode()) {
  //     FlavorMode.prod => prod.DefaultFirebaseOptions.currentPlatform,
  //     FlavorMode.staging => staging.DefaultFirebaseOptions.currentPlatform,
  //     FlavorMode.stable => stable.DefaultFirebaseOptions.currentPlatform,
  //     FlavorMode.dev => dev.DefaultFirebaseOptions.currentPlatform,
  //     _ => throw Exception('Unsupported flavor'),
  //   },
  // );
  //
  // await Future.wait([
  //   FirebaseCrashlyticsService.init(),
  //   FirebaseRemoteConfigService.init(locator<DeviceService>().getFlavorMode(), firebase),
  // ]);

  /// Init localization
  await EasyLocalization.ensureInitialized();
  EasyLocalization.logger.enableBuildModes = [];
  await locator<LocaleProvider>().init();

  /// Init navigation
  GoRouter.optionURLReflectsImperativeAPIs = true;

  /// Init in-app custom elements
  locator<InAppDialogsProvider>().init(AppRouter.key);
  locator<InAppOverlayProvider>().init(AppRouter.key);
}

class FlutterApp extends StatelessWidget {
  const FlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        /// Common
        BlocProvider.value(value: locator<AppBloc>()),
        BlocProvider.value(value: locator<CameraBloc>()),
      ],
      child: MultiProvider(
        providers: [
          /// Service
          ChangeNotifierProvider.value(value: locator<ThemeProvider>()),
          ChangeNotifierProvider.value(value: locator<NetworkProvider>()),
          ChangeNotifierProvider.value(value: locator<LoggerProvider>()),
          ChangeNotifierProvider.value(value: locator<LocaleProvider>()),
          /// In-app elements
          ChangeNotifierProvider.value(value: locator<InAppNotificationProvider>()),
          ChangeNotifierProvider.value(value: locator<InAppToastProvider>()),
          ChangeNotifierProvider.value(value: locator<InAppSliderProvider>()),
        ],
        builder: (context, _) {
          return MaterialApp.router(
            title: EnvironmentConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: ThemeConstants.light,
            darkTheme: ThemeConstants.dark,
            themeMode: context.watch<ThemeProvider>().mode,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            routerConfig: AppRouter.configs,
            builder: (context, screen) {
              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle(
                  statusBarBrightness: context.watch<ThemeProvider>().brightness,
                ),
                child: MediaQuery(
                  /// To prevent system text scaling
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.linear(1.0),
                  ),
                  child: DefaultTextStyle(
                    style: Theme.of(context).textTheme.bodyMedium!,
                    child: GestureDetector(
                      /// To hide keyboard if we touch the screen
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                          if (screen != null)
                            Positioned.fill(
                              child: ScreenBuilder(child: screen),
                            ),
                          SafeArea(
                            child: InAppNotificationBuilder(),
                          ),
                          if (locator<DeviceService>().getFlavorMode() != FlavorMode.prod)
                            Positioned(
                              bottom: 0.0,
                              right: 0.0,
                              child: DevBuildVersionPlaceholder(),
                            ),
                          if (locator<DeviceService>().showExperimentalFeatures && !context.watch<LoggerProvider>().isOpened)
                            Positioned(
                              bottom: 60.0,
                              right: 4.0,
                              child: LoggerScreen.button(
                                () => AppRouter.configs.pushNamed(LoggerScreen.routePath),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
