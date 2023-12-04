import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/models/service/usecase_model.dart';
import '../common/widgets/indicators/progress_indicator.dart';
import '../common/widgets/navigation_bar.dart';
import '../constants/images.dart';
import '../injection_container.dart';
import 'authentication/domain/bloc/auth_bloc.dart';
import 'authentication/domain/usecases/auth_auto_sign_in.dart';
import 'authentication/domain/usecases/auth_init.dart';
import 'home/screens/home_screen.dart';
import 'authentication/screens/welcome_screen.dart';
import 'home/screens/sandbox_screen.dart';
import 'home/screens/profile_screen.dart';
import 'splash_screen.dart';

/// This is the core of the entire app architecture
/// This is custom realisation for app with bottom navigation bar and [PageView] handler
class ScreenBuilder extends StatefulWidget {
  static const routeName = '/';
  static final globalKey = GlobalKey();

  const ScreenBuilder({Key? key}) : super(key: key);

  @override
  State<ScreenBuilder> createState() => _ScreenBuilderState();
}

class _ScreenBuilderState extends State<ScreenBuilder> with SingleTickerProviderStateMixin {
  final _pageController = PageController();
  late final AnimationController _animationController;
  late final Animation<double> _animatedOpacity;

  int _selectedPageNumber = HomeScreen.routeTabNumber;
  bool _isAutoSingInCompleted = false;
  bool _isSplashCompleted = false;
  bool _isAuthenticationCompleted = false;
  bool _isAnimationInProgress = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _animatedOpacity = Tween(begin: 1.0, end: 0.3).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );

    locator<AuthAutoSignIn>().call(NoParams()).then((_) {
      if (mounted) {
        setState(() {
          _isAutoSingInCompleted = true;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ImageConstants.precacheAssets(context);
  }

  void _onSplashCompletedHandler() {
    if (_isSplashCompleted) {
      return;
    }

    setState(() {
      _isSplashCompleted = true;
    });
  }

  Future<void> _onAuthenticationCompletedHandler() async {
    if (_isAuthenticationCompleted) {
      return;
    }

    await locator<AuthInit>().call(NoParams());

    setState(() {
      _isAuthenticationCompleted = true;
    });
  }

  Future<void> _onUpdateScreenHandler(int index) async {
    if (_isAnimationInProgress) {
      return;
    }

    if (_selectedPageNumber == index) {
      return;
    }

    _isAnimationInProgress = true;
    await _animationController.forward();

    setState(() {
      _selectedPageNumber = index;
      _pageController.jumpToPage(index);
    });

    await _animationController.reverse();
    _isAnimationInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      key: ScreenBuilder.globalKey,
      listenWhen: (prev, current) {
        return prev.authStatusType != current.authStatusType;
      },
      listener: (_, state) {
        Navigator.of(context).popUntil(ModalRoute.withName(ScreenBuilder.routeName));

        if (state.authStatusType == AuthStatusType.authenticated) {
          _onAuthenticationCompletedHandler();
        }

        if (state.authStatusType == AuthStatusType.unauthenticated) {
          setState(() {
            _selectedPageNumber = HomeScreen.routeTabNumber;
            _isAuthenticationCompleted = false;
          });
        }
      },
      buildWhen: (prev, current) {
        return prev.authStatusType != current.authStatusType;
      },
      builder: (_, state) {
        if (_isSplashCompleted == false || _isAutoSingInCompleted == false) {
          return SplashScreen(
            onFinish: _onSplashCompletedHandler,
          );
        }

        switch (state.authStatusType) {
          case AuthStatusType.unauthenticated:
            return const WelcomeScreen();

          case AuthStatusType.authenticated:
            return AbsorbPointer(
              absorbing: false,
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    Expanded(
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (_, child) {
                          if (_isAuthenticationCompleted == false) {
                            return const Center(
                              child: CustomProgressIndicator(
                                size: 30.0,
                              ),
                            );
                          }

                          return FadeTransition(
                            opacity: _animatedOpacity,
                            child: PageView(
                              controller: _pageController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: const [
                                HomeScreen(),
                                SandboxScreen(),
                                ProfileScreen(),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    CustomNavigationBar(
                      items: const [
                        NavigationBarData(
                          label: HomeScreen.routeTabName,
                          icon: Icon(Icons.home),
                          index: HomeScreen.routeTabNumber,
                        ),
                        NavigationBarData(
                          label: SandboxScreen.routeTabName,
                          icon: Icon(Icons.build),
                          index: SandboxScreen.routeTabNumber,
                        ),
                        NavigationBarData(
                          label: ProfileScreen.routeTabName,
                          icon: Icon(Icons.person),
                          index: ProfileScreen.routeTabNumber,
                        ),
                      ],
                      onSelect: _onUpdateScreenHandler,
                      selected: _selectedPageNumber,
                    ),
                  ],
                ),
              ),
            );
        }
      },
    );
  }
}
