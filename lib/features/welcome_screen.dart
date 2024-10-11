import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/common.dart';
import 'authentication/domain/bloc/auth_bloc.dart';

class WelcomeScreen extends StatefulWidget {
  static const routePath = '/';

  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      child: ContentWrapper(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 40.0,
        ),
        child: BlocBuilder<AuthBloc, AuthState>(
          buildWhen: (prev, current) {
            return prev.stateEvent != current.stateEvent;
          },
          builder: (_, state) {
            return CustomSlideAnimation(
              child: state.stateEvent == AuthStateType.initialSession
                  ? _SplashScreen()
                  : _AuthMethodsScreen(),
            );
          },
        ),
      ),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      mobile: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 95.0,
              child: Image.asset(
                ImageConstants.icLogo,
              ),
            ),
            const SizedBox(
              height: 32.0,
            ),
            const CustomProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class _AuthMethodsScreen extends StatefulWidget {
  @override
  State<_AuthMethodsScreen> createState() => _AuthMethodsScreenState();
}

class _AuthMethodsScreenState extends State<_AuthMethodsScreen> {
  void _onSignInHandler() {
    // AppRouter.configs.goNamed(SignInScreen.routePath);
  }

  void _onSignUpHandler() {
    // AppRouter.configs.goNamed(SignUpScreen.routePath);
  }

  Widget _buildAuthButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomTextButton(
          content: 'button.sign_in'.tr(),
          onTap: _onSignInHandler,
        ),
        const SizedBox(
          height: 32.0,
        ),
        GestureDetector(
          onTap: _onSignUpHandler,
          child: Container(
            padding: const EdgeInsets.all(4.0),
            color: ColorConstants.transparent,
            child: CustomText(
              text: 'button.sign_up'.tr(),
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: ColorConstants.textBlue(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      mobile: Column(
        children: [
          const Spacer(
            flex: 2,
          ),
          SizedBox(
            height: 95.0,
            child: Image.asset(
              ImageConstants.icLogo,
            ),
          ),
          const Spacer(),
          _buildAuthButtons(),
          const Spacer(
            flex: 2,
          ),
        ],
      ),
      tablet: Row(
        children: [
          SizedBox(
            height: 95.0,
            child: Image.asset(
              ImageConstants.icLogo,
            ),
          ),
          const SizedBox(
            width: 60.0,
          ),
          Expanded(
            child: _buildAuthButtons(),
          ),
        ],
      ),
    );
  }
}
