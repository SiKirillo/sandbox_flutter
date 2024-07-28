import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../common/services/in_app_toast/in_app_toast_provider.dart';
import '../../../common/widgets/buttons/base_button.dart';
import '../../../common/widgets/input_fields/input_validators.dart';
import '../../../common/widgets/input_fields/text_input_field.dart';
import '../../../common/widgets/texts.dart';
import '../../../common/widgets/wrappers/content_wrapper.dart';
import '../../../common/widgets/wrappers/opacity_wrapper.dart';
import '../../../common/widgets/wrappers/scaffold_wrapper.dart';
import '../../../common/widgets/wrappers/scrollable_wrapper.dart';
import '../../../constants/sizes.dart';
import '../../../injection_container.dart';
import '../domain/models/sign_in_model.dart';
import '../domain/usecases/auth_sign_in.dart';
import 'sign_up_email_screen.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/sign-in';

  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  String? _errorEmailMessage;
  String? _errorPasswordMessage;

  bool _isButtonEnabled = false;
  bool _isRequestInProgress = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_checkButtonDisability);
    _passwordController.addListener(_checkButtonDisability);
  }

  @override
  void dispose() {
    _emailController.removeListener(_checkButtonDisability);
    _passwordController.removeListener(_checkButtonDisability);
    super.dispose();
  }

  void _checkButtonDisability() {
    final isEnabled = _emailController.value.text.isNotEmpty &&
        _passwordController.value.text.isNotEmpty &&
        EmailValidator().call(_emailController.value.text) == null &&
        PasswordValidator().call(_passwordController.value.text) == null;

    if (_isButtonEnabled != isEnabled) {
      setState(() {
        _isButtonEnabled = isEnabled;
      });
    }
  }

  void _clearEmailErrorMessage() {
    if (_errorEmailMessage != null && _emailFocusNode.hasFocus) {
      setState(() {
        _errorEmailMessage = null;
      });
    }
  }

  void _clearPasswordErrorMessage() {
    if (_errorPasswordMessage != null && _passwordFocusNode.hasFocus) {
      setState(() {
        _errorPasswordMessage = null;
      });
    }
  }

  bool _isValidEmail() {
    _errorEmailMessage = EmailValidator().call(_emailController.value.text);
    if (_errorEmailMessage != null) {
      setState(() {
        _isRequestInProgress = false;
      });
      return false;
    }

    return true;
  }

  bool _isValidPassword() {
    _errorPasswordMessage = PasswordValidator().call(_passwordController.value.text);
    if (_errorPasswordMessage != null) {
      setState(() {
        _isRequestInProgress = false;
      });
      return false;
    }

    return true;
  }

  void _resetErrorMessage() {
    if (_errorEmailMessage != null || _errorPasswordMessage != null) {
      setState(() {
        _errorEmailMessage = null;
        _errorPasswordMessage = null;
      });
    }

    locator<InAppToastProvider>().clear();
  }

  Future<void> _onLogInHandler() async {
    if (_isRequestInProgress) {
      return;
    }

    setState(() {
      _isRequestInProgress = true;
    });

    FocusScope.of(context).unfocus();
    _resetErrorMessage();
    if (!_isValidEmail() || !_isValidPassword()) return;

    final response = await locator<AuthSignIn>().call(
      SignInData(
        email: _emailController.value.text,
        password: _passwordController.value.text,
      ),
    );

    response.fold(
      (failure) async {
        locator<InAppToastProvider>().addToast(
          InAppToastData.failure(
            key: const ValueKey(SignInScreen.routeName),
            failure: failure,
          ),
        );
      },
      (result) => null,
    );

    setState(() {
      _isRequestInProgress = false;
    });
  }

  void _onCreateAccountHandler() {
    Navigator.of(context).pushReplacementNamed(SignUpEmailScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      isDisabled: _isRequestInProgress,
      child: ContentWrapper(
        padding: ContentWrapper.defaultPadding.copyWith(
          top: 0.0,
          bottom: 0.0,
        ),
        child: ScrollableWrapper(
          padding: ScrollableWrapper.defaultPadding.copyWith(
            top: SizeConstants.defaultAppBarSize + 12.0,
          ),
          child: Column(
            children: [
              OpacityWrapper(
                isOpaque: _isRequestInProgress,
                child: Column(
                  children: [
                    CustomText(
                      text: 'Sign in',
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    CustomRichText(
                      span: TextSpan(
                        children: const [
                          TextSpan(
                            text: 'Enter your data to Authorization in\n',
                          ),
                          TextSpan(
                            text: 'Flutter Sandbox',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    CustomTextInputField(
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      hintText: 'Email',
                      errorText: _errorEmailMessage,
                      keyboardType: TextInputType.emailAddress,
                      inputAction: TextInputAction.next,
                      onChanged: (_) {
                        _clearEmailErrorMessage();
                      },
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                      onFocusChange: (value) {
                        if (!value) {
                          _isValidEmail();
                        }
                      },
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    CustomTextInputField(
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      hintText: 'Password',
                      errorText: _errorPasswordMessage,
                      isProtectedField: true,
                      onChanged: (_) {
                        _clearPasswordErrorMessage();
                      },
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      },
                      onFocusChange: (value) {
                        if (!value) {
                          _isValidPassword();
                        }
                      },
                    ),
                    const InAppToastBackground(
                      key: ValueKey(SignInScreen.routeName),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              CustomBaseButton(
                content: 'Let\'s Start!',
                onCallback: _onLogInHandler,
                isBlocked: !_isButtonEnabled,
                isProcessing: _isRequestInProgress,
              ),
              const SizedBox(
                height: 20.0,
              ),
              OpacityWrapper(
                isOpaque: _isRequestInProgress,
                child: CustomRichText(
                  span: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Have no account? ',
                      ),
                      TextSpan(
                        text: 'Create account',
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = _onCreateAccountHandler,
                      ),
                    ],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
