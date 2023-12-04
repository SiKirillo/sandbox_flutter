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
import 'sign_in_screen.dart';
import 'sign_up_personal_screen.dart';

class SignUpEmailScreen extends StatefulWidget {
  static const routeName = '/sign-up-email';

  const SignUpEmailScreen({Key? key}) : super(key: key);

  @override
  State<SignUpEmailScreen> createState() => _SignUpEmailScreenState();
}

class _SignUpEmailScreenState extends State<SignUpEmailScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  String? _errorEmailMessage;
  String? _errorPasswordMessage;
  String? _errorConfirmPasswordMessage;

  bool _showIsEmailValid = false;
  bool _showIsPasswordValid = false;
  bool _showIsConfirmPasswordValid = false;
  bool _showPasswordHelperText = false;

  bool _isButtonEnabled = false;
  bool _isRequestInProgress = false;

  @override
  void initState() {
    _emailController.addListener(_checkButtonDisability);
    _passwordController.addListener(_checkButtonDisability);
    _confirmPasswordController.addListener(_checkButtonDisability);
    super.initState();
  }

  @override
  void dispose() {
    _emailController.removeListener(_checkButtonDisability);
    _passwordController.removeListener(_checkButtonDisability);
    _confirmPasswordController.removeListener(_checkButtonDisability);
    super.dispose();
  }

  void _checkButtonDisability() {
    final isEnabled = _emailController.value.text.isNotEmpty &&
        _passwordController.value.text.isNotEmpty &&
        _confirmPasswordController.value.text.isNotEmpty &&
        EmailValidator().call(_emailController.value.text) == null &&
        PasswordValidator().call(_passwordController.value.text) == null &&
        PasswordConfirmValidator(compareWith: _confirmPasswordController.value.text).call(_passwordController.value.text) == null;

    if (_isButtonEnabled != isEnabled && mounted) {
      setState(() {
        _isButtonEnabled = isEnabled;
      });
    }
  }

  void _clearEmailErrorMessage() {
    if (_errorEmailMessage != null && _emailFocusNode.hasFocus && mounted) {
      setState(() {
        _errorEmailMessage = null;
      });
    }
  }

  void _clearPasswordErrorMessage() {
    if (_errorPasswordMessage != null && _passwordFocusNode.hasFocus && mounted) {
      setState(() {
        _errorPasswordMessage = null;
      });
    }
  }

  void _clearConfirmPasswordErrorMessage() {
    if (_errorConfirmPasswordMessage != null && _confirmPasswordFocusNode.hasFocus && mounted) {
      setState(() {
        _errorConfirmPasswordMessage = null;
      });
    }
  }

  bool _isValidEmail() {
    _errorEmailMessage = EmailValidator().call(_emailController.value.text);
    if (_errorEmailMessage != null && mounted) {
      setState(() {
        _isRequestInProgress = false;
        _showIsEmailValid = false;
      });
      return false;
    }

    setState(() {
      _showIsEmailValid = _emailController.value.text.isNotEmpty;
    });

    return true;
  }

  bool _isValidPassword() {
    _errorPasswordMessage = PasswordValidator().call(_passwordController.value.text);
    if (_errorPasswordMessage != null && mounted) {
      setState(() {
        _isRequestInProgress = false;
        _showIsPasswordValid = false;
      });
      return false;
    }

    setState(() {
      _showIsPasswordValid = _passwordController.value.text.isNotEmpty;
    });

    return true;
  }

  bool _isValidConfirmPassword() {
    _errorConfirmPasswordMessage = PasswordConfirmValidator(compareWith: _confirmPasswordController.value.text).call(_passwordController.value.text);
    if (_errorConfirmPasswordMessage != null && mounted) {
      setState(() {
        _isRequestInProgress = false;
        _showIsConfirmPasswordValid = false;
      });
      return false;
    }

    setState(() {
      _showIsConfirmPasswordValid = _confirmPasswordController.value.text.isNotEmpty;
    });

    return true;
  }

  void _showPasswordHelper(bool isFocused) {
    setState(() {
      _showPasswordHelperText = isFocused && !_showIsPasswordValid;
    });
  }

  void _resetErrorMessage() {
    if (_errorEmailMessage != null || _errorPasswordMessage != null || _errorConfirmPasswordMessage != null) {
      setState(() {
        _errorEmailMessage = null;
        _errorPasswordMessage = null;
        _errorConfirmPasswordMessage = null;
      });
    }

    locator<InAppToastProvider>().clear();
  }

  Future<void> _onContinueHandler() async {
    if (_isRequestInProgress) {
      return;
    }

    setState(() {
      _isRequestInProgress = true;
    });

    FocusScope.of(context).unfocus();
    if (!_isValidEmail() || !_isValidPassword() || !_isValidConfirmPassword()) {
      return;
    }
    _resetErrorMessage();

    await Future.delayed(const Duration(milliseconds: 500));
    Navigator.of(context).pushNamed(
      SignUpPersonalScreen.routeName,
      arguments: SignInData(
        email: _emailController.value.text,
        password: _passwordController.value.text,
      ),
    );

    setState(() {
      _isRequestInProgress = false;
    });
  }

  void _onLogInHandler() {
    Navigator.of(context).pushReplacementNamed(SignInScreen.routeName);
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
                      text: 'Sign up',
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
                            text: 'Enter your data to create an account in\n',
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
                      isValidField: _showIsEmailValid,
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
                      helperText: _showPasswordHelperText
                          ? 'The password must be a minimum of 6 characters and a maximum of 10 characters.'
                          : null,
                      inputAction: TextInputAction.next,
                      isValidField: _showIsPasswordValid,
                      isProtectedField: true,
                      onChanged: (_) {
                        _clearPasswordErrorMessage();
                      },
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
                      },
                      onFocusChange: (value) {
                        _showPasswordHelper(value);
                        if (!value) {
                          _isValidPassword();
                          _isValidConfirmPassword();
                        }
                      },
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    CustomTextInputField(
                      controller: _confirmPasswordController,
                      focusNode: _confirmPasswordFocusNode,
                      hintText: 'Confirm',
                      errorText: _errorConfirmPasswordMessage,
                      isValidField: _showIsConfirmPasswordValid,
                      isProtectedField: true,
                      onChanged: (_) {
                        _clearConfirmPasswordErrorMessage();
                      },
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      },
                      onFocusChange: (value) {
                        if (!value) {
                          _isValidConfirmPassword();
                        }
                      },
                    ),
                    const InAppToastBackground(
                      key: ValueKey(SignUpEmailScreen.routeName),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              CustomBaseButton(
                content: 'Continue',
                onCallback: _onContinueHandler,
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
                        text: 'Already have an account? ',
                      ),
                      TextSpan(
                        text: 'Log in',
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = _onLogInHandler,
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
