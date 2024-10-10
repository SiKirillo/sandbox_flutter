import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'common/common.dart';
import 'common/injection_container.dart';
import 'common/services/in_app_notifications/in_app_notification_provider.dart';
import 'common/services/in_app_slider/in_app_slider_provider.dart';
import 'common/services/in_app_toast/in_app_toast_provider.dart';
import 'features/authentication/domain/bloc/auth_bloc.dart';
import 'features/screen_builder.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  initLocator();
  await Future.wait([
    locator<DeviceService>().init(),
    AbstractSharedPreferencesDatasource.init(),
  ]);

  await EasyLocalization.ensureInitialized();
  EasyLocalization.logger.enableBuildModes = [];

  GoRouter.optionURLReflectsImperativeAPIs = true;
  if (kIsWeb) {
    usePathUrlStrategy();
  }

  await locator<SupabaseService>().init();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: ColorConstants.statusBarColor(),
  ));

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
      ],
      fallbackLocale: const Locale('en'),
      path: 'assets/translations',
      useOnlyLangCode: true,
      useFallbackTranslations: true,
      child: const SandboxApp(),
    ),
  );
}

class SandboxApp extends StatelessWidget {
  const SandboxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: locator<AuthBloc>()),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: locator<ThemeProvider>()),
          ChangeNotifierProvider.value(value: locator<InAppNotificationProvider>()),
          ChangeNotifierProvider.value(value: locator<InAppSliderProvider>()),
          ChangeNotifierProvider.value(value: locator<InAppToastProvider>()),
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
                value: const SystemUiOverlayStyle(
                  statusBarBrightness: Brightness.light,
                ),
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: const TextScaler.linear(1.0),
                  ),
                  child: DefaultTextStyle(
                    style: Theme.of(context).textTheme.bodyMedium!,
                    child: GestureDetector(
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
                              child: ScreenBuilder(
                                child: screen,
                              ),
                            ),
                          const SafeArea(
                            child: InAppNotificationBackground(),
                          ),
                          if (locator<DeviceService>().getBuildModeFromArgs() != BuildMode.prod)
                            const Positioned(
                              bottom: 0.0,
                              right: 0.0,
                              child: DevBuildVersionBackground(),
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