import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../providers/theme_provider.dart';
import '../buttons/icon_button.dart';
import '../texts.dart';

class SandboxTextInputField extends StatefulWidget {
  final TextEditingController controller;
  final String? labelText, hintText, errorText, helperText;
  final Widget? prefixIcon, suffixIcon;
  final bool isDisabled, isAutofocused, isValidField;
  final bool isOptionalField, isProtectedField;
  final bool allowSpaces;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final TextInputAction inputAction;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? formatters;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode autovalidateMode;
  final int maxLength, maxLines;
  final Function(String)? onChanged;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onTap;
  final Function(bool)? onFocusChange;

  const SandboxTextInputField({
    Key? key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.errorText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.isDisabled = false,
    this.isAutofocused = false,
    this.isValidField = false,
    this.isOptionalField = false,
    this.isProtectedField = false,
    this.allowSpaces = false,
    this.focusNode,
    this.keyboardType = TextInputType.visiblePassword,
    this.inputAction = TextInputAction.done,
    this.autofillHints,
    this.formatters,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.maxLength = 64,
    this.maxLines = 1,
    this.onChanged,
    this.onEditingComplete,
    this.onTap,
    this.onFocusChange,
  })  : assert(maxLength >= 0),
        assert(maxLines >= 1),
        super(key: key);

  @override
  State<SandboxTextInputField> createState() => _SandboxTextInputFieldState();
}

class _SandboxTextInputFieldState extends State<SandboxTextInputField> {
  bool _isFocused = false;
  bool _isProtected = false;
  bool _showOptionalHintText = true;

  @override
  void initState() {
    super.initState();
    _isProtected = widget.isProtectedField;

    _hintTextHandler();
    if (widget.isOptionalField) {
      widget.controller.addListener(_hintTextHandler);
    }
  }

  @override
  void dispose() {
    if (widget.isOptionalField) {
      widget.controller.removeListener(_hintTextHandler);
    }
    super.dispose();
  }

  void _hintTextHandler() {
    final isEmpty = widget.controller.value.text.isEmpty;
    if (_showOptionalHintText != isEmpty) {
      setState(() {
        _showOptionalHintText = isEmpty;
      });
    }
  }

  void _onToggleObscureHandler() {
    setState(() {
      _isProtected = !_isProtected;
    });
  }

  void _onChangedHandler(String value) {
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  void _onFocusChangeHandler(bool value) async {
    setState(() {
      _isFocused = value;
    });

    if (widget.onFocusChange != null) {
      widget.onFocusChange!(value);
    }
  }

  Widget _buildErrorWidget() {
    return SandboxText(
      text: widget.errorText!,
      style: Theme.of(context).inputDecorationTheme.errorStyle,
      maxLines: Theme.of(context).inputDecorationTheme.errorMaxLines ?? 1,
    );
  }

  Widget _buildHelperWidget() {
    return SandboxText(
      text: widget.helperText!,
      style: Theme.of(context).inputDecorationTheme.helperStyle,
      maxLines: Theme.of(context).inputDecorationTheme.helperMaxLines ?? 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    final showOptionalHint = widget.isOptionalField && _showOptionalHintText && widget.hintText != null;
    final showOptionalWithPrefix = showOptionalHint && widget.prefixIcon != null && !_isFocused;

    final focusedColor = context.watch<ThemeProvider>().type == ThemeStyleType.light
        ? ColorConstants.light.blue200.withOpacity(0.6)
        : ColorConstants.dark.blue300.withOpacity(0.6);
    final cursorColor = context.watch<ThemeProvider>().type == ThemeStyleType.light
        ? ColorConstants.dark.blue300
        : ColorConstants.dark.white400;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Focus(
              onFocusChange: _onFocusChangeHandler,
              child: TextFormField(
                controller: widget.controller,
                enabled: !widget.isDisabled,
                obscureText: _isProtected,
                autofocus: widget.isAutofocused,
                focusNode: widget.focusNode,
                keyboardType: widget.keyboardType,
                textInputAction: widget.inputAction,
                style: Theme.of(context).inputDecorationTheme.labelStyle?.copyWith(
                  decorationThickness: 0.0,
                  color: widget.isDisabled ? Theme.of(context).inputDecorationTheme.disabledBorder?.borderSide.color : null,
                ),
                decoration: InputDecoration(
                  hintText: widget.isOptionalField ? null : widget.hintText,
                  prefixIcon: widget.prefixIcon,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (widget.isProtectedField)
                          SandboxIconButton(
                            icon: Icon(
                              _isProtected ? Icons.visibility : Icons.visibility_off,
                            ),
                            onCallback: _onToggleObscureHandler,
                            color: Theme.of(context).inputDecorationTheme.iconColor,
                          ),
                        if (widget.isValidField) ...[
                          const SizedBox(
                            width: 4.0,
                          ),
                          SandboxIconButton(
                            icon: const Icon(Icons.check),
                            onCallback: () {},
                            color: Theme.of(context).inputDecorationTheme.iconColor,
                          ),
                        ],
                        if (widget.suffixIcon != null) widget.suffixIcon!,
                      ],
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minHeight: SizeConstants.defaultIconSize,
                  ),
                  suffixIconConstraints: const BoxConstraints(
                    minHeight: SizeConstants.defaultIconSize,
                  ),
                  enabledBorder: widget.errorText != null ? Theme.of(context).inputDecorationTheme.errorBorder : null,
                  focusedBorder: widget.errorText != null ? Theme.of(context).inputDecorationTheme.errorBorder : null,
                  fillColor: _isFocused ? focusedColor : null,
                ),
                autofillHints: widget.autofillHints,
                inputFormatters: [
                  ...widget.formatters ?? [],
                  if (!widget.allowSpaces) FilteringTextInputFormatter.deny(RegExp(r'[\r\n\t\f\v ]')),
                  LengthLimitingTextInputFormatter(widget.maxLength),
                ],
                cursorColor: cursorColor,
                cursorWidth: 1.0,
                validator: widget.validator,
                autovalidateMode: widget.autovalidateMode,
                maxLines: widget.maxLines,
                onChanged: _onChangedHandler,
                onEditingComplete: widget.onEditingComplete,
                onTap: widget.onTap,
              ),
            ),
            if (widget.errorText != null) ...[
              const SizedBox(
                height: 6.0,
              ),
              _buildErrorWidget(),
            ],
            if (widget.helperText != null && widget.errorText == null) ...[
              const SizedBox(
                height: 6.0,
              ),
              _buildHelperWidget(),
            ],
          ],
        ),
        if (widget.prefixIcon == null ? showOptionalHint : showOptionalWithPrefix)
          Positioned(
            top: 16.0 - (Theme.of(context).inputDecorationTheme.border?.borderSide.width ?? 1.0),
            left: 16.0,
            child: SandboxRichText(
              span: TextSpan(
                text: widget.hintText,
                children: [
                  TextSpan(
                    text: '*',
                    style: TextStyle(
                      color: ColorConstants.light.red500.withOpacity(0.5),
                    ),
                  ),
                ],
                style: Theme.of(context).inputDecorationTheme.hintStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    widget.focusNode?.requestFocus();
                  },
              ),
            ),
          ),
        if (widget.labelText != null)
          Positioned(
            top: -4.0,
            left: 12.0,
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.symmetric(
                horizontal: 4.0,
              ),
              child: SandboxText(
                text: widget.labelText!,
                style: TextStyle(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w400,
                  height: 1.0,
                  color: ColorConstants.light.black400,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
