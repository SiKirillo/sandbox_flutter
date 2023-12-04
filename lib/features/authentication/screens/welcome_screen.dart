import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/buttons/base_button.dart';
import '../../../common/widgets/texts.dart';
import '../../../common/widgets/wrappers/content_wrapper.dart';
import '../../../common/widgets/wrappers/scaffold_wrapper.dart';
import '../../../constants/images.dart';
import '../../../constants/sizes.dart';
import '../../../injection_container.dart';
import '../domain/bloc/auth_bloc.dart';
import '../domain/usecases/auth_update_status.dart';
import 'sign_up_email_screen.dart';
import 'sign_in_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  void _onSignUpHandler(BuildContext context) {
    Navigator.of(context).pushNamed(SignUpEmailScreen.routeName);
  }

  void _onSignInHandler(BuildContext context) {
    Navigator.of(context).pushNamed(SignInScreen.routeName);
  }

  void _onSkipAuthHandler() {
    locator<AuthUpdateStatus>().call(AuthStatusType.authenticated);
  }

  @override
  Widget build(BuildContext context) {

    return ScaffoldWrapper(
      child: ContentWrapper(
        padding: ContentWrapper.defaultPadding.copyWith(
          top: SizeConstants.defaultAppBarSize + 12.0,
        ),
        child: Column(
          children: [
            CustomText(
              text: 'Welcome\nto Flutter Sandbox',
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 12.0,
            ),
            const CustomText(
              text: 'This mobile app providing free flutter widgets and solutions. Sign in & up just show an example of authentication processing',
              textAlign: TextAlign.center,
              maxLines: 4,
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Spacer(),
            SizedBox(
              height: 140.0,
              child: Image.asset(ImageConstants.igLunchCat),
            ),
            const Spacer(
              flex: 2,
            ),
            const SizedBox(
              height: 20.0,
            ),
            CustomBaseButton(
              content: 'Sign up',
              onCallback: () => _onSignUpHandler(context),
            ),
            const SizedBox(
              height: 10.0,
            ),
            CustomBaseButton(
              content: 'Sign In',
              onCallback: () => _onSignInHandler(context),
            ),
            const SizedBox(
              height: 20.0,
            ),
            CustomRichText(
              span: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Continue without account? ',
                  ),
                  TextSpan(
                    text: 'Skip',
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w500,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = _onSkipAuthHandler,
                  ),
                ],
                style: Theme.of(context).textTheme.bodySmall,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
