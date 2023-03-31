import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../common/models/in_app_toast_model.dart';
import '../../../common/usecases/core_update_in_app_toast.dart';
import '../../../common/widgets/buttons/text_button.dart';
import '../../../common/widgets/in_app_elements/in_app_toast.dart';
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
import '../domain/models/sign_up_model.dart';
import '../domain/usecases/auth_sign_up.dart';
import 'sign_in_screen.dart';

class SignUpPersonalScreen extends StatefulWidget {
  static const routeName = '/sign-up-personal';

  final SignInData signInData;

  const SignUpPersonalScreen({
    Key? key,
    required this.signInData,
  }) : super(key: key);

  @override
  State<SignUpPersonalScreen> createState() => _SignUpPersonalScreenState();
}

class _SignUpPersonalScreenState extends State<SignUpPersonalScreen> {
  final _nicknameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  final _nicknameFocusNode = FocusNode();
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();

  String? _errorNicknameMessage;
  String? _errorFirstNameMessage;
  String? _errorLastNameMessage;

  bool _showIsNicknameValid = false;
  bool _showIsFirstNameValid = false;
  bool _showIsLastNameValid = false;

  bool _isButtonEnabled = false;
  bool _isRequestInProgress = false;

  @override
  void initState() {
    _nicknameController.addListener(_checkButtonDisability);
    _firstNameController.addListener(_checkButtonDisability);
    _lastNameController.addListener(_checkButtonDisability);
    super.initState();
  }

  @override
  void dispose() {
    _nicknameController.removeListener(_checkButtonDisability);
    _firstNameController.removeListener(_checkButtonDisability);
    _lastNameController.removeListener(_checkButtonDisability);
    super.dispose();
  }

  void _checkButtonDisability() {
    final isEnabled = _nicknameController.value.text.isNotEmpty &&
        NicknameValidator().call(_nicknameController.value.text) == null &&
        NameValidator().call(_firstNameController.value.text) == null &&
        NameValidator().call(_lastNameController.value.text) == null;

    if (_isButtonEnabled != isEnabled && mounted) {
      setState(() {
        _isButtonEnabled = isEnabled;
      });
    }
  }

  void _clearNicknameErrorMessage() {
    if (_errorNicknameMessage != null && _nicknameFocusNode.hasFocus && mounted) {
      setState(() {
        _errorNicknameMessage = null;
      });
    }
  }

  void _clearFirstNameErrorMessage() {
    if (_errorFirstNameMessage != null && _firstNameFocusNode.hasFocus && mounted) {
      setState(() {
        _errorFirstNameMessage = null;
      });
    }
  }

  void _clearLastNameErrorMessage() {
    if (_errorLastNameMessage != null && _lastNameFocusNode.hasFocus && mounted) {
      setState(() {
        _errorLastNameMessage = null;
      });
    }
  }

  bool _isValidNickname() {
    _errorNicknameMessage = NicknameValidator().call(_nicknameController.value.text);
    if (_errorNicknameMessage != null) {
      setState(() {
        _isRequestInProgress = false;
        _showIsNicknameValid = false;
      });
      return false;
    }

    setState(() {
      _showIsNicknameValid = _nicknameController.value.text.isNotEmpty;
    });

    return true;
  }

  bool _isValidFirstName() {
    _errorFirstNameMessage = NameValidator().call(_firstNameController.value.text);
    if (_errorFirstNameMessage != null) {
      setState(() {
        _isRequestInProgress = false;
        _showIsFirstNameValid = false;
      });
      return false;
    }

    setState(() {
      _showIsFirstNameValid = _firstNameController.value.text.isNotEmpty;
    });

    return true;
  }

  bool _isValidLastName() {
    _errorLastNameMessage = NameValidator().call(_lastNameController.value.text);
    if (_errorLastNameMessage != null) {
      setState(() {
        _isRequestInProgress = false;
        _showIsLastNameValid = false;
      });
      return false;
    }

    setState(() {
      _showIsLastNameValid = _lastNameController.value.text.isNotEmpty;
    });

    return true;
  }

  void _resetErrorMessage() {
    if (_errorNicknameMessage != null || _errorFirstNameMessage != null || _errorLastNameMessage != null) {
      setState(() {
        _errorNicknameMessage = null;
        _errorFirstNameMessage = null;
        _errorLastNameMessage = null;
      });
    }

    locator<CoreUpdateInAppToast>().call(null);
  }

  Future<void> _onSignUpHandler() async {
    if (_isRequestInProgress) {
      return;
    }

    setState(() {
      _isRequestInProgress = true;
    });

    FocusScope.of(context).unfocus();
    if (!_isValidNickname() || !_isValidFirstName() || !_isValidLastName()) {
      return;
    }
    _resetErrorMessage();

    final response = await locator<AuthSignUp>().call(
      SignUpData(
        email: widget.signInData.email,
        password: widget.signInData.password,
        nickname: _firstNameController.value.text,
        firstName: _firstNameController.value.text,
        lastName: _firstNameController.value.text,
      ),
    );

    response.fold(
      (failure) {
        locator<CoreUpdateInAppToast>().call(
          InAppToastData.createFromFailure(
            key: const ValueKey(SignUpPersonalScreen.routeName),
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
                    SandboxText(
                      text: 'Sign up',
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    SandboxRichText(
                      span: TextSpan(
                        children: const [
                          TextSpan(
                            text: 'Enter your personal data to create an account in\n',
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
                    SandboxTextInputField(
                      controller: _nicknameController,
                      focusNode: _nicknameFocusNode,
                      hintText: 'Nickname',
                      errorText: _errorNicknameMessage,
                      keyboardType: TextInputType.emailAddress,
                      inputAction: TextInputAction.next,
                      isValidField: _showIsNicknameValid,
                      onChanged: (_) {
                        _clearNicknameErrorMessage();
                      },
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(_firstNameFocusNode);
                      },
                      onFocusChange: (value) {
                        if (!value) {
                          _isValidNickname();
                        }
                      },
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    SandboxTextInputField(
                      controller: _firstNameController,
                      focusNode: _firstNameFocusNode,
                      hintText: 'First name',
                      errorText: _errorFirstNameMessage,
                      keyboardType: TextInputType.emailAddress,
                      inputAction: TextInputAction.next,
                      isValidField: _showIsFirstNameValid,
                      isOptionalField: true,
                      onChanged: (_) {
                        _clearFirstNameErrorMessage();
                      },
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(_lastNameFocusNode);
                      },
                      onFocusChange: (value) {
                        if (!value) {
                          _isValidFirstName();
                        }
                      },
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    SandboxTextInputField(
                      controller: _lastNameController,
                      focusNode: _lastNameFocusNode,
                      hintText: 'Last name',
                      errorText: _errorLastNameMessage,
                      keyboardType: TextInputType.emailAddress,
                      isValidField: _showIsLastNameValid,
                      isOptionalField: true,
                      onChanged: (_) {
                        _clearLastNameErrorMessage();
                      },
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      },
                      onFocusChange: (value) {
                        if (!value) {
                          _isValidLastName();
                        }
                      },
                    ),
                    const InAppToastBackground(
                      key: ValueKey(SignUpPersonalScreen.routeName),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              SandboxTextButton(
                content: 'Let\'s Start!',
                onCallback: _onSignUpHandler,
                isDisabled: !_isButtonEnabled,
                isProcessing: _isRequestInProgress,
              ),
              const SizedBox(
                height: 20.0,
              ),
              OpacityWrapper(
                isOpaque: _isRequestInProgress,
                child: SandboxRichText(
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
