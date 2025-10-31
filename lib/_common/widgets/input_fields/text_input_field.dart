part of '../../common.dart';

class CustomTextInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode, nextFocusNode;
  final String? labelText, hintText, errorText, helperText;
  final Widget? prefixIcon, suffixIcon;
  final bool isDisabled, isAutofocused, isValidField, isProcessing;
  final bool isOptionalField, isProtectedField;
  final TextInputType keyboardType;
  final TextInputAction inputAction;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? formatters;
  final CustomInputFieldOptions options;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onTap;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<bool>? onFocusChange;
  final VoidCallback? onClear;

  const CustomTextInputField({
    super.key,
    required this.controller,
    this.focusNode,
    this.nextFocusNode,
    this.labelText,
    this.hintText,
    this.errorText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.isDisabled = false,
    this.isAutofocused = false,
    this.isValidField = false,
    this.isProcessing = false,
    this.isOptionalField = false,
    this.isProtectedField = false,
    this.keyboardType = TextInputType.text,
    this.inputAction = TextInputAction.done,
    this.autofillHints,
    this.formatters,
    this.options = const CustomInputFieldOptions(),
    this.onChanged,
    this.onEditingComplete,
    this.onTap,
    this.onFieldSubmitted,
    this.onFocusChange,
    this.onClear,
  });

  @override
  State<CustomTextInputField> createState() => _CustomTextInputFieldState();
}

class _CustomTextInputFieldState extends State<CustomTextInputField> {
  late final FocusNode _focusNode;

  bool _isFocused = false;
  bool _isProtected = false;
  bool _isFieldEmpty = true;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _isProtected = widget.isProtectedField;
    _hintTextHandler();
    widget.controller.addListener(_hintTextHandler);
  }

  void _hintTextHandler() {
    final isEmpty = widget.controller.value.text.isEmpty;
    if (_isFieldEmpty != isEmpty) {
      setState(() {
        _isFieldEmpty = isEmpty;
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

  void _onClearFieldHandler() {
    widget.controller.clear();
    if (widget.onClear != null) {
      widget.onClear!();
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

  KeyEventResult _onKeyEventHandler(FocusNode focus, KeyEvent event) {
    if (event is KeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.goBack) {
        return KeyEventResult.ignored;
      }

      return KeyEventResult.handled;
    }

    final isShiftEnterPressed = HardwareKeyboard.instance.isShiftPressed && event.logicalKey == LogicalKeyboardKey.enter;
    final isTabPressed = event.logicalKey == LogicalKeyboardKey.tab;

    if (isShiftEnterPressed || isTabPressed) {
      if (event is KeyRepeatEvent) {
        return KeyEventResult.handled;
      }

      if (isTabPressed && widget.nextFocusNode != null) {
        FocusScope.of(context).requestFocus(widget.nextFocusNode);
      }

      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  TextStyle _getTextStyle() {
    final textStyle = Theme.of(context).inputDecorationTheme.labelStyle!.copyWith(
      color: ColorConstants.textFieldText(),
      decorationThickness: 0.0,
    );

    /// On disabled
    if (widget.isDisabled) {
      return textStyle.copyWith(
        color: ColorConstants.textFieldTextDisable(),
      );
    }

    return textStyle;
  }

  TextStyle _getLabelTextStyle() {
    final isLabelShown = widget.controller.text.isNotEmpty || _isFocused;
    final textStyle = Theme.of(context).inputDecorationTheme.labelStyle!.copyWith(
      color: Theme.of(context).inputDecorationTheme.labelStyle!.color,
      decorationThickness: 0.0,
    );

    /// On disabled
    if (widget.isDisabled) {
      return textStyle.copyWith(
        color: ColorConstants.textFieldTextDisable(),
      );
    }

    /// On error
    if (isLabelShown && widget.errorText != null) {
      return textStyle.copyWith(
        color: ColorConstants.textFieldBorderError(),
      );
    }

    /// On focused
    if (isLabelShown && _isFocused) {
      return textStyle.copyWith(
        color: ColorConstants.textFieldBorderFocused(),
      );
    }

    return textStyle;
  }

  TextStyle _getHintTextStyle() {
    return Theme.of(context).inputDecorationTheme.hintStyle!.copyWith(
      color: Theme.of(context).inputDecorationTheme.labelStyle!.color,
      decorationThickness: 0.0,
    );
  }

  Color _getIconColor({bool isProtected = false, bool isProcessing = false}) {
    /// On disabled
    if (widget.isDisabled) {
      return ColorConstants.textFieldIconDisable();
    }

    /// On disabled protected
    if (isProtected) {
      return _isProtected
          ? ColorConstants.textFieldIcon()
          : ColorConstants.textFieldIconActive();
    }

    /// On error
    if (widget.errorText != null) {
      return ColorConstants.textFieldIconError();
    }

    /// On focused processing
    if (isProcessing && widget.isProcessing && _isFocused) {
      return ColorConstants.textFieldBorderFocused();
    }

    /// On focused & default
    return ColorConstants.textFieldIconActive();
  }

  Widget? _buildLabelWidget() {
    if (widget.labelText == null) return null;
    return CustomRichText(
      span: TextSpan(
        text: widget.labelText,
        children: [
          if (widget.isOptionalField)
            TextSpan(
              text: '*',
              style: TextStyle(
                height: 1.0,
                color: widget.isDisabled
                    ? ColorConstants.textFieldIconDisable()
                    : ColorConstants.textFieldIconError(),
              ),
            ),
        ],
      ),
    );
  }

  Widget? _buildPrefixIconWidget() {
    if (widget.prefixIcon == null) return null;
    if (!widget.options.showPrefixWhileFocused && _isFocused) return null;
    return Padding(
      padding: EdgeInsets.only(
        left: widget.options.prefixPadding.left,
        right: widget.options.prefixPadding.right,
      ),
      child: widget.prefixIcon,
    );
  }

  Widget? _buildSuffixIconWidget() {
    final textStyle = Theme.of(context).inputDecorationTheme.labelStyle;
    final suffixIconBottomPadding = (textStyle?.fontSize ?? 0.0) * (textStyle?.height ?? 0.0);

    return Padding(
      padding: EdgeInsets.only(
        left: widget.options.suffixPadding.left,
        right: widget.options.suffixPadding.right,
        bottom: (widget.options.maxLines - 1) * suffixIconBottomPadding,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (widget.options.withClearButton && !_isFieldEmpty && _isFocused)
            CustomIconButton(
              content: SvgPicture.asset(
                ImageConstants.icTextfieldClean,
                height: 16.0,
                width: 16.0,
              ),
              onTap: _onClearFieldHandler,
              options: CustomButtonOptions(
                size: 20.0,
                padding: EdgeInsets.all(2.0),
              ),
            ),
          if (widget.isValidField) ...[
            SizedBox(width: 4.0),
            CustomIconButton(
              content: SvgPicture.asset(
                ImageConstants.icTextfieldOk,
                height: 16.0,
                width: 16.0,
              ),
              onTap: () {},
              options: CustomButtonOptions(
                size: 20.0,
                padding: EdgeInsets.all(2.0),
              ),
              isDisabled: true,
            ),
          ],
          if (widget.isProcessing) ...[
            SizedBox(width: 4.0),
            CustomProgressIndicator.simple(
              size: 12.0,
              color: _getIconColor(isProcessing: true),
            ),
          ],
          if (widget.isProtectedField) ...[
            if (widget.options.withClearButton && !_isFieldEmpty && _isFocused)
              SizedBox(width: 4.0),
            CustomIconButton(
              content: SvgPicture.asset(
                ImageConstants.icTextfieldEye,
                height: 16.0,
                width: 16.0,
                colorFilter: ColorFilter.mode(_getIconColor(isProtected: true), BlendMode.srcIn),
              ),
              onTap: _onToggleObscureHandler,
              options: CustomButtonOptions(
                size: 20.0,
                padding: EdgeInsets.all(2.0),
              ),
            ),
          ],
          if (widget.suffixIcon != null) ...[
            SizedBox(width: 4.0),
            widget.suffixIcon!
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Focus(
          onFocusChange: _onFocusChangeHandler,
          onKeyEvent: _onKeyEventHandler,
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: widget.keyboardType,
            textInputAction: widget.inputAction,
            style: _getTextStyle(),
            decoration: InputDecoration(
              label: _buildLabelWidget(),
              hintText: widget.hintText,
              labelStyle: _getLabelTextStyle(),
              hintStyle: _getHintTextStyle(),
              prefixIcon: _buildPrefixIconWidget(),
              suffixIcon: _buildSuffixIconWidget(),
              isDense: true,
              fillColor: ColorConstants.textFieldBG(),
              prefixIconConstraints: BoxConstraints(
                minHeight: SizeConstants.defaultButtonIconSize,
              ),
              suffixIconConstraints: BoxConstraints(
                minHeight: SizeConstants.defaultButtonIconSize,
              ),
              border: Theme.of(context).inputDecorationTheme.border,
              enabledBorder: widget.errorText != null
                  ? Theme.of(context).inputDecorationTheme.errorBorder
                  : Theme.of(context).inputDecorationTheme.border?.copyWith(
                      borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
              focusedBorder: widget.errorText != null
                  ? Theme.of(context).inputDecorationTheme.errorBorder
                  : null,
              disabledBorder: Theme.of(context).inputDecorationTheme.disabledBorder,
            ),
            inputFormatters: [
              ...widget.formatters ?? [],
              if (!widget.options.allowSpaces)
                FilteringTextInputFormatter.deny(RegExp(r'\s')),
              if (!widget.options.allowUncommonSymbols)
                UncommonSymbolsInputFormatter(),
              LengthLimitingTextInputFormatter(widget.options.maxLength),
            ],
            cursorColor: widget.errorText != null
                ? Theme.of(context).inputDecorationTheme.errorBorder?.borderSide.color
                : Theme.of(context).inputDecorationTheme.focusedBorder?.borderSide.color,
            cursorWidth: 1.0,
            cursorOpacityAnimates: !kIsWeb,
            maxLengthEnforcement: widget.options.maxLengthEnforcement,
            maxLines: widget.options.maxLines,
            autofillHints: widget.autofillHints,
            enabled: !widget.isDisabled,
            obscureText: _isProtected,
            autofocus: widget.isAutofocused,
            onChanged: _onChangedHandler,
            onEditingComplete: widget.onEditingComplete,
            onFieldSubmitted: widget.onFieldSubmitted,
            onTap: widget.onTap,
          ),
        ),
        if (!widget.isDisabled) ...[
          _TextInputFieldHelper(
            text: widget.helperText,
            isShowing: widget.helperText != null && widget.helperText != '',
          ),
          _TextInputFieldError(
            text: widget.errorText,
            isShowing: widget.errorText != null && widget.errorText != '',
          ),
        ],
      ],
    );
  }
}

class _TextInputFieldHelper extends StatefulWidget {
  final String? text;
  final bool isShowing;

  const _TextInputFieldHelper({
    required this.text,
    required this.isShowing,
  });

  @override
  State<_TextInputFieldHelper> createState() => _TextInputFieldHelperState();
}

class _TextInputFieldHelperState extends State<_TextInputFieldHelper> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  String? _helperText;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: OtherConstants.defaultAnimationDuration,
    );
    _helperText = widget.text;
  }

  @override
  void didUpdateWidget(covariant _TextInputFieldHelper oldWidget) {
    if (widget.isShowing) {
      _animationController.forward();
      _helperText = widget.text;
    } else {
      _animationController.reverse();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildHelperWidget(BuildContext context) {
    if (_helperText != null && _helperText != '') {
      return CustomText(
        text: _helperText!,
        style: Theme.of(context).inputDecorationTheme.helperStyle,
        maxLines: Theme.of(context).inputDecorationTheme.helperMaxLines,
      );
    }

    return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, child) {
        return Container(
          margin: EdgeInsets.only(
            top: _animationController.value * 6.0,
          ),
          child: Opacity(
            opacity: _animationController.value,
            child: Align(
              heightFactor: _animationController.value,
              child: Transform.scale(
                scaleY: _animationController.value,
                child: Row(
                  children: [
                    _buildHelperWidget(context),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TextInputFieldError extends StatefulWidget {
  final String? text;
  final bool isShowing;

  const _TextInputFieldError({
    required this.text,
    required this.isShowing,
  });

  @override
  State<_TextInputFieldError> createState() => _TextInputFieldErrorState();
}

class _TextInputFieldErrorState extends State<_TextInputFieldError> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: OtherConstants.defaultAnimationDuration,
    );
    _errorText = widget.text;
  }

  @override
  void didUpdateWidget(covariant _TextInputFieldError oldWidget) {
    if (widget.isShowing) {
      _animationController.forward();
      _errorText = widget.text;
    } else {
      _animationController.reverse();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildErrorWidget(BuildContext context) {
    if (_errorText != null && _errorText != '') {
      return CustomText(
        text: _errorText!,
        style: Theme.of(context).inputDecorationTheme.errorStyle,
        maxLines: Theme.of(context).inputDecorationTheme.errorMaxLines,
        isVerticalCentered: false,
      );
    }

    return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, child) {
        return Container(
          margin: EdgeInsets.only(
            top: _animationController.value * 6.0,
          ),
          child: Opacity(
            opacity: _animationController.value,
            child: Align(
              heightFactor: _animationController.value,
              child: Transform.scale(
                scaleY: _animationController.value,
                child: Container(
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: ColorConstants.textFieldTextErrorBG(),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        ImageConstants.icError,
                        height: 16.0,
                        width: 16.0,
                      ),
                      SizedBox(width: 8.0),
                      Flexible(
                        child: _buildErrorWidget(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomInputFieldOptions {
  final bool allowSpaces, allowUncommonSymbols;
  final bool withClearButton;
  final bool showPrefixWhileFocused;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final EdgeInsets prefixPadding, suffixPadding;
  final int maxLength, maxLines;

  const CustomInputFieldOptions({
    this.allowSpaces = true,
    this.allowUncommonSymbols = false,
    this.withClearButton = true,
    this.showPrefixWhileFocused = true,
    this.maxLengthEnforcement,
    this.prefixPadding = const EdgeInsets.fromLTRB(12.0, 0.0, 4.0, 0.0),
    this.suffixPadding = const EdgeInsets.fromLTRB(4.0, 0.0, 12.0, 0.0),
    this.maxLength = 64,
    this.maxLines = 1,
  })  : assert(maxLength >= 0),
        assert(maxLines >= 1);
}
