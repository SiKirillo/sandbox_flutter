import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sandbox_flutter/constants/colors.dart';

import 'common/bloc/core_bloc.dart';
import 'common/models/service/shared_preferences_datasource_model.dart';
import 'common/models/service/usecase_model.dart';
import 'common/providers/charles_provider.dart';
import 'common/providers/network_provider.dart';
import 'common/services/device_service.dart';
import 'common/services/firebase_service.dart';
import 'common/services/in_app_failures/in_app_failure_provider.dart';
import 'common/services/in_app_notifications/in_app_notification_provider.dart';
import 'common/services/navigation_service.dart';
import 'common/usecases/core_init.dart';
import 'common/providers/theme_provider.dart';
import 'common/widgets/in_app_elements/dev_build_version.dart';
import 'constants/themes.dart';
import 'features/authentication/domain/bloc/auth_bloc.dart';
import 'features/authentication/domain/models/sign_in_model.dart';
import 'features/authentication/screens/sign_up_email_screen.dart';
import 'features/authentication/screens/sign_in_screen.dart';
import 'features/authentication/screens/sign_up_personal_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/home/screens/sandbox_screen.dart';
import 'features/home/screens/profile_screen.dart';
import 'features/screen_builder.dart';
import 'injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: ColorConstants.systemNavigationBar,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  initLocator();
  await Future.wait([
    locator<DeviceService>().init(),
    locator<FirebaseService>().init(),
    AbstractSharedPreferencesDatasource.init(),
  ]);

  await locator<CoreInit>().call(NoParams());
  runApp(const SandboxApp());
}

class SandboxApp extends StatefulWidget {
  const SandboxApp({Key? key}) : super(key: key);

  @override
  State<SandboxApp> createState() => _SandboxAppState();
}

class _SandboxAppState extends State<SandboxApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: locator<CoreBloc>()),
        BlocProvider.value(value: locator<AuthBloc>()),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: locator<ThemeProvider>()),
          ChangeNotifierProvider.value(value: locator<NetworkProvider>()),
          ChangeNotifierProvider.value(value: locator<CharlesProvider>()),
        ],
        builder: (context, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeConstants.light,
            darkTheme: ThemeConstants.dark,
            themeMode: context.watch<ThemeProvider>().mode,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', 'EN'),
            ],
            initialRoute: ScreenBuilder.routeName,
            routes: {
              ScreenBuilder.routeName: (context) => const ScreenBuilder(),
            },
            onGenerateRoute: (settings) {
              switch (settings.name) {
                /// Authorization
                case SignInScreen.routeName:
                  return NavigationService.getPageRoute(
                    const SignInScreen(),
                  );

                case SignUpEmailScreen.routeName:
                  return NavigationService.getPageRoute(
                    const SignUpEmailScreen(),
                  );

                case SignUpPersonalScreen.routeName:
                  return NavigationService.getPageRoute(
                    SignUpPersonalScreen(
                      signInData: settings.arguments as SignInData,
                    ),
                  );

                /// Home
                case HomeScreen.routeName:
                  return NavigationService.getPageRoute(
                    const HomeScreen(),
                  );

                case SandboxScreen.routeName:
                  return NavigationService.getPageRoute(
                    const SandboxScreen(),
                  );

                case ProfileScreen.routeName:
                  return NavigationService.getPageRoute(
                    const ProfileScreen(),
                  );
              }

              return null;
            },
            builder: (context, screen) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: 1.0,
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
                            child: screen,
                          ),
                        const SafeArea(
                          child: InAppNotificationBackground(),
                        ),
                        const Positioned.fill(
                          child: InAppFailureBackground(),
                        ),
                        if (locator<DeviceService>().currentBuildMode() != BuildMode.prod)
                          const Positioned(
                            bottom: 0.0,
                            right: 0.0,
                            child: DevBuildVersionBackground(),
                          ),
                      ],
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
