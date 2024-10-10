part of '../common/common.dart';

class AppRouter {
  AppRouter._();

  static final _rootRouterKey = GlobalKey<NavigatorState>();
  static final _authorizedOnlyRoutes = <String>{
    // ContactsScreen.routePath,
    // ChatsScreen.routePath,
    // ChatDetailsScreen.routePath,
    // SettingsScreen.routePath,
    // SettingsAccountScreen.routePath,
    // SettingsProfileScreen.routePath,
  };

  static final _notAuthorizedOnlyRoutes = <String>{
    // WelcomeScreen.routePath,
    // SignInScreen.routePath,
    // SignUpScreen.routePath,
    // ForgotPasswordScreen.routePath,
    // ResetPasswordScreen.routePath,
  };

  static final configs = GoRouter(
    navigatorKey: _rootRouterKey,
    initialLocation: WelcomeScreen.routePath,
    redirect: (context, state) {
      if (locator<AuthBloc>().state.stateEvent == AuthStateType.signedIn) {
        if (_notAuthorizedOnlyRoutes.contains(state.matchedLocation)) {
          // return ChatsScreen.routePath;
        } else {
          return null;
        }
      }

      if (_authorizedOnlyRoutes.contains(state.matchedLocation)) {
        return WelcomeScreen.routePath;
      } else {
        return null;
      }
    },
    routes: [
      GoRoute(
        path: WelcomeScreen.routePath,
        name: WelcomeScreen.routePath,
        pageBuilder: (_, state) => _defaultSwipeablePageBuilder(
          state.pageKey,
          const WelcomeScreen(),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => HomeBuilder(
          navigationShell: navigationShell,
        ),
        branches: <StatefulShellBranch>[
          // StatefulShellBranch(
          //   routes: [
          //     GoRoute(
          //       path: ContactsScreen.routePath,
          //       name: ContactsScreen.routePath,
          //       pageBuilder: (context, state) => _defaultSwipeablePageBuilder(
          //         state.pageKey,
          //         const ContactsScreen(),
          //       ),
          //     ),
          //   ],
          // ),
          // StatefulShellBranch(
          //   routes: [
          //     GoRoute(
          //       path: ChatsScreen.routePath,
          //       name: ChatsScreen.routePath,
          //       pageBuilder: (context, state) => _defaultSwipeablePageBuilder(
          //         state.pageKey,
          //         const ChatsScreen(),
          //       ),
          //       routes: [
          //         GoRoute(
          //           path: ChatDetailsScreen.routePath,
          //           name: ChatDetailsScreen.routePath,
          //           parentNavigatorKey: _rootRouterKey,
          //           pageBuilder: (context, state) => _defaultSwipeablePageBuilder(
          //             state.pageKey,
          //             ChatDetailsScreen(
          //               chatID: state.pathParameters['chatID'],
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
          // StatefulShellBranch(
          //   routes: [
          //     GoRoute(
          //       path: SettingsScreen.routePath,
          //       name: SettingsScreen.routePath,
          //       pageBuilder: (context, state) => _defaultSwipeablePageBuilder(
          //         state.pageKey,
          //         const SettingsScreen(),
          //       ),
          //       routes: [
          //         GoRoute(
          //           path: SettingsAccountScreen.routePath,
          //           name: SettingsAccountScreen.routePath,
          //           parentNavigatorKey: _rootRouterKey,
          //           pageBuilder: (context, state) => _defaultSwipeablePageBuilder(
          //             state.pageKey,
          //             const SettingsAccountScreen(),
          //           ),
          //         ),
          //         GoRoute(
          //           path: SettingsProfileScreen.routePath,
          //           name: SettingsProfileScreen.routePath,
          //           parentNavigatorKey: _rootRouterKey,
          //           pageBuilder: (context, state) => _defaultSwipeablePageBuilder(
          //             state.pageKey,
          //             const SettingsProfileScreen(),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
        ],
      ),
    ],
  );

  static SwipeablePage _defaultSwipeablePageBuilder(
    LocalKey? key,
    Widget screen, {
    bool canSwipe = true,
  }) {
    return SwipeablePage(
      key: key,
      canSwipe: canSwipe && !kIsWeb,
      canOnlySwipeFromEdge: true,
      builder: (context) => screen,
    );
  }
}