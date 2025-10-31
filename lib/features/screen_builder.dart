part of '../_common/common.dart';

class ScreenBuilder extends StatefulWidget {
  final Widget child;

  const ScreenBuilder({
    super.key,
    required this.child,
  });

  @override
  State<ScreenBuilder> createState() => _ScreenBuilderState();
}

class _ScreenBuilderState extends State<ScreenBuilder> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    locator<AppBloc>().add(Init_AppEvent());
    Future.delayed(Duration.zero).then((_) {
      if (mounted) {
        SystemChrome.setPreferredOrientations(locator<DeviceService>().orientations(context));
        ImageConstants.precacheAssets(context);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onWelcomeStepHandler() {
    // AppRouter.configs.goNamed(LoginScreen.routePath);
  }

  void _onLoggedInStepHandler() {
    // AppRouter.configs.goNamed(HomeScreen.routePath);
  }

  void _onLoggedOutStepHandler() {
    // AppRouter.configs.goNamed(LoginScreen.routePath);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listenWhen: (prev, current) {
        return prev.status != current.status;
      },
      listener: (context, state) {
        switch (state.status) {
          case AppStatus.welcome: {
            _onWelcomeStepHandler();
            break;
          }

          case AppStatus.loggedIn: {
            _onLoggedInStepHandler();
            break;
          }

          case AppStatus.loggedOut: {
            _onLoggedOutStepHandler();
            break;
          }

          default:
            break;
        }
      },
      child: widget.child,
    );
  }
}
