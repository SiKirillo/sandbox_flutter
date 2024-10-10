import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/common.dart';
import '../common/injection_container.dart';
import 'authentication/domain/bloc/auth_bloc.dart';

class ScreenBuilder extends StatefulWidget {
  static final globalKey = GlobalKey();

  final Widget child;

  const ScreenBuilder({
    super.key,
    required this.child,
  });

  static BuildContext context(BuildContext context) {
    return ScreenBuilder.globalKey.currentContext ?? context;
  }

  @override
  State<ScreenBuilder> createState() => _ScreenBuilderState();
}

class _ScreenBuilderState extends State<ScreenBuilder> with WidgetsBindingObserver {
  AppLifecycleState _lifecycleState = AppLifecycleState.resumed;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    locator<SupabaseService>().onStartListener();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ImageConstants.precacheAssets(context);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == _lifecycleState) return;
    // if (locator<AuthBloc>().state.authEvent != AuthStateType.signedIn) return;

    // switch (state) {
    //   case AppLifecycleState.resumed: {
    //     locator<AuthUpdateUserStatus>().call(UserStatusType.online);
    //     break;
    //   }
    //
    //   case AppLifecycleState.inactive: {
    //     break;
    //   }
    //
    //   default:
    //     locator<AuthUpdateUserStatus>().call(UserStatusType.offline);
    // }

    _lifecycleState = state;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onSignInStepHandler() {
    // AppRouter.configs.goNamed(ChatsScreen.routePath);
    // locator<HomeInit>().call(NoParams());
  }

  void _onSignOutStepHandler() {
    // AppRouter.configs.goNamed(WelcomeScreen.routePath);
  }

  void _onPasswordRecoveryStepHandler() {

  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      key: ScreenBuilder.globalKey,
      listenWhen: (prev, current) {
        return prev.stateEvent != current.stateEvent;
      },
      listener: (_, state) {
        switch (state.stateEvent) {
          case AuthStateType.signedIn: {
            _onSignInStepHandler();
            break;
          }

          case AuthStateType.signedOut: {
            _onSignOutStepHandler();
            break;
          }

          case AuthStateType.passwordRecovery: {
            _onPasswordRecoveryStepHandler();
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
