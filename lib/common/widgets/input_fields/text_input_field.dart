// ignore_for_file: deprecated_member_use

part of '../../common.dart';

class CustomTextInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode, nextFocusNode;
  final String? labelText, hintText, errorText, helperText;
  final Widget? prefixIcon, suffixIcon;
  final bool isEnabled, isAutofocused, isValidField, isOnError, isProcessing;
  final bool isOptionalField, isProtectedField;
  final TextInputType keyboardType;
  final TextInputAction inputAction;
  final CustomInputFieldOptions options;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? formatters;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode autovalidateMode;
  final Function(String)? onChanged;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onTap;
  final Function(String)? onFieldSubmitted;
  final Function(bool)? onFocusChange;
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
    this.isEnabled = true,
    this.isAutofocused = false,
    this.isValidField = false,
    this.isOnError = false,
    this.isProcessing = false,
    this.isOptionalField = false,
    this.isProtectedField = false,
    this.keyboardType = TextInputType.visiblePassword,
    this.inputAction = TextInputAction.done,
    this.options = const CustomInputFieldOptions(),
    this.autofillHints,
    this.formatters,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
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

class _CustomTextInputFieldState extends State<CustomTextInputField> with WidgetsBindingObserver {
  final _textFieldKey = GlobalKey();
  final _prefixIconKey = GlobalKey();
  final _suffixIconKey = GlobalKey();

  late final FocusNode _focusNode;

  double _textFieldSize = 0.0;
  double _prefixIconSize = 0.0;
  double _suffixIconSize = 0.0;

  bool _isFocused = false;
  bool _isProtected = false;
  bool _isFieldEmpty = true;
  bool _isInit = false;

  static const _defaultInfoSectionDuration = Duration(milliseconds: 300);
  static const _defaultLabelDuration = Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleWidgetSize();
      Future.delayed(StyleConstants.defaultUsecaseDelayDuration).then((_) {
        if (mounted) {
          setState(() {
            _isInit = true;
          });
        }
      });
    });

    _isProtected = widget.isProtectedField;
    _hintTextHandler();
    widget.controller.addListener(_hintTextHandler);
  }

  @override
  void didUpdateWidget(covariant CustomTextInputField oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleWidgetSize();
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.controller.removeListener(_hintTextHandler);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      _handleWidgetSize();
    });
  }

  void _handleWidgetSize() {
    if (!mounted) return;
    if (widget.labelText == null && widget.hintText == null) {
      return;
    }

    final textFieldContext = _textFieldKey.currentContext;
    final prefixContext = _prefixIconKey.currentContext;
    final suffixContext = _suffixIconKey.currentContext;

    final textFieldRenderSize = textFieldContext?.size?.width ?? 0.0;
    final prefixRenderSize = prefixContext?.size?.width ?? 0.0;
    final suffixRenderSize = suffixContext?.size?.width ?? 0.0;

    if (_textFieldSize != textFieldRenderSize && textFieldRenderSize > 0.0) {
      setState(() {
        _textFieldSize = textFieldRenderSize;
      });
    }

    if (_prefixIconSize != prefixRenderSize && (prefixRenderSize > 0.0 || widget.prefixIcon == null)) {
      setState(() {
        _prefixIconSize = prefixRenderSize;
      });
    }

    if (_suffixIconSize != suffixRenderSize && (suffixRenderSize > 0.0 || widget.suffixIcon == null)) {
      setState(() {
        _suffixIconSize = suffixRenderSize;
      });
    }
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
      return KeyEventResult.handled;
    }

    final isShiftEnterPressed = HardwareKeyboard.instance.isShiftPressed && event.logicalKey == LogicalKeyboardKey.enter;
    final isTabPressed = event.logicalKey == LogicalKeyboardKey.tab;

    if (isTabPressed && widget.nextFocusNode != null) {}

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

  TextStyle _getLabelTextStyle() {
    final defaultTextStyle = Theme.of(context).inputDecorationTheme.labelStyle!.merge(widget.options.textStyle).copyWith(
      decorationThickness: 0.0,
    );

    /// On disabled
    if (!widget.isEnabled) {
      return defaultTextStyle.copyWith(
        color: defaultTextStyle.color?.withOpacity(0.5),
      );
    }

    return defaultTextStyle;
  }

  TextStyle _getHintTextStyle() {
    final defaultTextStyle = Theme.of(context).inputDecorationTheme.hintStyle!.copyWith(
      decorationThickness: 0.0,
    );

    /// On disabled
    if (!widget.isEnabled) {
      return defaultTextStyle.copyWith(
        color: defaultTextStyle.color?.withOpacity(0.5),
      );
    }

    return defaultTextStyle;
  }

  TextStyle _getAnimatedLabelTextStyle() {
    final isLabelShown = widget.controller.text.isNotEmpty;
    final defaultTextStyle = Theme.of(context).inputDecorationTheme.hintStyle!.copyWith(
      fontSize: 12.0,
      fontWeight: FontWeight.w400,
      height: 1.0,
      decorationThickness: 0.0,
    );

    /// On disabled
    if (!widget.isEnabled) {
      return defaultTextStyle.copyWith(
        color: defaultTextStyle.color?.withOpacity(0.5),
      );
    }

    /// On error
    if ((isLabelShown || _isFocused) && widget.errorText != null) {
      return defaultTextStyle.copyWith(
        color: widget.isEnabled
            ? Theme.of(context).inputDecorationTheme.errorStyle?.color
            : defaultTextStyle.color?.withOpacity(0.5),
      );
    }

    /// On focused
    if (isLabelShown || _isFocused) {
      return defaultTextStyle.copyWith(
        color: _isFocused
            ? ColorConstants.textFieldFocusedBorderColor()
            : defaultTextStyle.color,
      );
    }

    /// On unfocused
    return Theme.of(context).inputDecorationTheme.hintStyle!;
  }

  Color _getIconColor({bool isProtectedIcon = false}) {
    /// On disabled
    if (!widget.isEnabled) {
      return ColorConstants.textFieldIconDisableColor();
    }

    /// On disabled protected
    if (_isProtected && isProtectedIcon) {
      return ColorConstants.textFieldIconColor();
    }

    /// On error
    if (widget.errorText != null) {
      return ColorConstants.textFieldErrorColor();
    }

    /// On focused
    return ColorConstants.textFieldIconFocusedColor();
  }

  Widget _buildErrorWidget() {
    return AnimatedContainer(
      alignment: Alignment.centerLeft,
      duration: _defaultInfoSectionDuration,
      padding: EdgeInsets.symmetric(
        vertical: _isFocused ? 0.0 : 10.0,
        horizontal: _isFocused ? 0.0 : 12.0,
      ),
      decoration: BoxDecoration(
        color: _isFocused
            ? null
            : Theme.of(context).inputDecorationTheme.errorStyle?.color?.withOpacity(0.2),
        borderRadius: const BorderRadius.all(Radius.circular(6.0)),
      ),
      child: AnimatedDefaultTextStyle(
        duration: _defaultInfoSectionDuration,
        style: Theme.of(context).inputDecorationTheme.errorStyle!.copyWith(
          fontSize: _isFocused ? null : 12.0,
          height: _isFocused ? null : 16.0 / 12.0,
        ),
        child: CustomText(
          isVerticalCentered: false,
          text: widget.errorText!,
          maxLines: Theme.of(context).inputDecorationTheme.errorMaxLines,
        ),
      ),
    );
  }

  Widget _buildHelperWidget() {
    return CustomText(
      text: widget.helperText!,
      style: Theme.of(context).inputDecorationTheme.helperStyle,
      maxLines: Theme.of(context).inputDecorationTheme.helperMaxLines,
    );
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).inputDecorationTheme.labelStyle;
    final suffixIconBottomPadding = (labelStyle?.fontSize ?? 0.0) * (labelStyle?.height ?? 0.0);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Focus(
              onFocusChange: _onFocusChangeHandler,
              onKeyEvent: _onKeyEventHandler,
              child: Opacity(
                opacity: widget.isEnabled ? 1.0 : 0.5,
                child: Center(
                  child: TextFormField(
                    key: _textFieldKey,
                    controller: widget.controller,
                    enabled: widget.isEnabled,
                    obscureText: _isProtected,
                    autofocus: widget.isAutofocused,
                    focusNode: _focusNode,
                    keyboardType: widget.keyboardType,
                    textInputAction: widget.inputAction,
                    style: _getLabelTextStyle(),
                    decoration: InputDecoration(
                      isDense: widget.options.isDense,
                      prefixIcon: widget.prefixIcon != null
                          ? Padding(
                              key: _prefixIconKey,
                              padding: EdgeInsets.only(
                                left: SizeConstants.defaultTextInputPadding.left,
                              ),
                              child: widget.prefixIcon,
                            )
                          : null,
                      suffixIcon: Padding(
                        key: _suffixIconKey,
                        padding: EdgeInsets.only(
                          bottom: (widget.options.maxLines - 1) * suffixIconBottomPadding,
                          left: SizeConstants.defaultTextInputPadding.right,
                          right: SizeConstants.defaultTextInputPadding.right,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (widget.options.withClearButton && !_isFieldEmpty && _isFocused) ...[
                              CustomIconButton(
                                icon: SvgPicture.asset(
                                  ImageConstants.icClose,
                                ),
                                onTap: _onClearFieldHandler,
                              ),
                              const SizedBox(
                                width: 4.0,
                              ),
                            ],
                            if (widget.isProtectedField)
                              CustomIconButton(
                                icon: SvgPicture.asset(
                                  ImageConstants.icTextfieldEye,
                                  color: _getIconColor(isProtectedIcon: true),
                                ),
                                onTap: _onToggleObscureHandler,
                              ),
                            if (widget.isValidField) ...[
                              const SizedBox(
                                width: 4.0,
                              ),
                              CustomIconButton(
                                icon: SvgPicture.asset(
                                  ImageConstants.icTextfieldOk,
                                  color: _getIconColor(),
                                ),
                                onTap: () {},
                              ),
                            ],
                            if (widget.isProcessing) ...[
                              const SizedBox(
                                width: 4.0,
                              ),
                              CustomProgressIndicator.simple(
                                size: 16.0,
                                color: _getIconColor(),
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
                      border: Theme.of(context).inputDecorationTheme.border?.copyWith(
                        borderSide: Theme.of(context).inputDecorationTheme.border?.borderSide.copyWith(
                          color: widget.isEnabled ? null : ColorConstants.textFieldBorderColor(),
                        ),
                      ),
                      enabledBorder: widget.errorText != null || widget.isOnError
                          ? Theme.of(context).inputDecorationTheme.errorBorder
                          : null,
                      focusedBorder: widget.errorText != null || widget.isOnError
                          ? Theme.of(context).inputDecorationTheme.errorBorder
                          : null,
                      disabledBorder: Theme.of(context).inputDecorationTheme.disabledBorder?.copyWith(
                        borderSide: Theme.of(context).inputDecorationTheme.disabledBorder?.borderSide.copyWith(
                          color: ColorConstants.textFieldBorderColor(),
                        ),
                      ),
                      contentPadding: widget.options.contentPadding,
                    ),
                    inputFormatters: [
                      ...widget.formatters ?? [],
                      if (!widget.options.allowSpaces)
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                      if (!widget.options.allowUncommonSymbols)
                        UncommonSymbolsInputFormatter(),
                      LengthLimitingTextInputFormatter(widget.options.maxLength),
                    ],
                    cursorColor: widget.errorText == null
                        ? Theme.of(context).inputDecorationTheme.focusedBorder?.borderSide.color
                        : Theme.of(context).inputDecorationTheme.errorBorder?.borderSide.color,
                    cursorWidth: 1.0,
                    cursorOpacityAnimates: !kIsWeb,
                    validator: widget.validator,
                    autovalidateMode: widget.autovalidateMode,
                    maxLengthEnforcement: widget.options.maxLengthEnforcement,
                    maxLines: widget.options.maxLines,
                    autofillHints: widget.autofillHints,
                    onChanged: _onChangedHandler,
                    onEditingComplete: widget.onEditingComplete,
                    onFieldSubmitted: widget.onFieldSubmitted,
                    onTap: widget.onTap,
                  ),
                ),
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
        if (widget.hintText != null && widget.labelText == null)
          _InputFieldHintText(
            hintText: widget.hintText!,
            isOptionalField: widget.isOptionalField,
            isFieldEmpty: _isFieldEmpty,
            textFieldSize: _textFieldSize,
            prefixIconSize: _prefixIconSize,
            suffixIconSize: _suffixIconSize,
            options: widget.options,
            duration: _defaultLabelDuration,
            textStyle: _getHintTextStyle(),
            onTap: () {
              _focusNode.requestFocus();
            },
          ),
        if (widget.labelText != null) ...[
          _InputFieldLabelText(
            labelText: widget.labelText!,
            isLabelShownOnTop: _isFocused || !_isFieldEmpty,
            isOptionalField: widget.isOptionalField,
            isEnabled: widget.isEnabled,
            isInit: _isInit,
            textFieldSize: _textFieldSize,
            prefixIconSize: _prefixIconSize,
            suffixIconSize: _suffixIconSize,
            duration: _defaultLabelDuration,
            textStyle: _getAnimatedLabelTextStyle(),
            type: widget.options.type,
            isOnTopPosition: true,
            onTap: () {
              _focusNode.requestFocus();
            },
          ),
          _InputFieldLabelText(
            labelText: widget.labelText!,
            isLabelShownOnTop: _isFocused || !_isFieldEmpty,
            isOptionalField: widget.isOptionalField,
            isEnabled: widget.isEnabled,
            isInit: _isInit,
            textFieldSize: _textFieldSize,
            prefixIconSize: _prefixIconSize,
            suffixIconSize: _suffixIconSize,
            duration: _defaultLabelDuration,
            textStyle: _getAnimatedLabelTextStyle(),
            type: widget.options.type,
            isOnTopPosition: false,
            onTap: () {
              _focusNode.requestFocus();
            },
          ),
        ],
      ],
    );
  }
}

class _InputFieldLabelText extends StatefulWidget {
  final String labelText;
  final bool isLabelShownOnTop, isOptionalField, isEnabled, isInit;
  final double textFieldSize, prefixIconSize, suffixIconSize;
  final Duration duration;
  final TextStyle textStyle;
  final CustomTextInputFieldType type;
  final bool isOnTopPosition;
  final VoidCallback onTap;

  const _InputFieldLabelText({
    required this.labelText,
    required this.isLabelShownOnTop,
    required this.isOptionalField,
    required this.isEnabled,
    required this.isInit,
    required this.textFieldSize,
    required this.prefixIconSize,
    required this.suffixIconSize,
    required this.duration,
    required this.textStyle,
    this.type = CustomTextInputFieldType.scaffold,
    required this.isOnTopPosition,
    required this.onTap,
  });

  @override
  State<_InputFieldLabelText> createState() => _InputFieldLabelTextState();
}

class _InputFieldLabelTextState extends State<_InputFieldLabelText> {
  double _getLabelCollapsedTextSize() {
    final labelCollapsedPainter = TextPainter(
      text: TextSpan(
        text: widget.labelText + (widget.isOptionalField ? '*' : ''),
        style: Theme.of(context).inputDecorationTheme.labelStyle?.copyWith(
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
          height: 1.0,
        ),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: double.maxFinite);

    return labelCollapsedPainter.size.width;
  }

  double _getLabelExpandedTextSize() {
    final labelExpandedPainter = TextPainter(
      text: TextSpan(
        text: widget.labelText + (widget.isOptionalField ? '*' : ''),
        style: Theme.of(context).inputDecorationTheme.labelStyle,
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: double.maxFinite);

    return labelExpandedPainter.size.width;
  }

  Color? _getBackgroundColor(BuildContext context) {
    switch (widget.type) {
      case CustomTextInputFieldType.scaffold:
        return Theme.of(context).scaffoldBackgroundColor;

      case CustomTextInputFieldType.dialog:
        return Theme.of(context).dialogTheme.backgroundColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderWidth = Theme.of(context).inputDecorationTheme.border?.borderSide.width ?? 1.0;
    final defaultTopPosition = SizeConstants.defaultTextInputPadding.top - borderWidth;
    final defaultLeftPosition = widget.prefixIconSize > 0.0 ? widget.prefixIconSize : SizeConstants.defaultTextInputPadding.left;
    final defaultRightPosition = widget.suffixIconSize > 0.0 ? widget.suffixIconSize + 8.0 : SizeConstants.defaultTextInputPadding.right;
    final maxLabelWidth = widget.textFieldSize - defaultLeftPosition - defaultRightPosition;

    if (widget.isOnTopPosition) {
      return Positioned(
        top: 0.0,
        left: 12.0,
        width: _getLabelCollapsedTextSize() + 8.0 > 0
            ? _getLabelCollapsedTextSize() + 8.0
            : null,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedOpacity(
            duration: widget.isInit ? widget.duration : Duration.zero,
            opacity: widget.isLabelShownOnTop ? 1.0 : 0.0,
            child: Container(
              height: 10.0,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(4.0),
                  bottomRight: Radius.circular(4.0),
                ),
                color: _getBackgroundColor(context),
              ),
            ),
          ),
        ),
      );
    }

    final currentLabelWidth = widget.isLabelShownOnTop
        ? _getLabelCollapsedTextSize() + 2.0
        : _getLabelExpandedTextSize() + 2.0;
    final labelWidth = currentLabelWidth > maxLabelWidth
        ? maxLabelWidth
        : currentLabelWidth;

    return AnimatedPositioned(
      duration: widget.isInit ? widget.duration : Duration.zero,
      top: widget.isLabelShownOnTop ? -4.0 : defaultTopPosition,
      left: widget.isLabelShownOnTop ? SizeConstants.defaultTextInputPadding.left : defaultLeftPosition,
      width: labelWidth > 0 ? labelWidth : null,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: widget.isInit ? widget.duration : Duration.zero,
          style: widget.textStyle,
          child: CustomRichText(
            span: TextSpan(
              text: widget.labelText,
              children: [
                if (widget.isOptionalField)
                  TextSpan(
                    text: '*',
                    style: TextStyle(
                      height: 1.0,
                      color: widget.isEnabled
                          ? ColorConstants.attentionColor().withOpacity(widget.isLabelShownOnTop ? 1.0 : 0.5)
                          : widget.textStyle.color,
                    ),
                  ),
              ],
            ),
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}

class _InputFieldHintText extends StatefulWidget {
  final String hintText;
  final bool isOptionalField, isFieldEmpty;
  final double textFieldSize, prefixIconSize, suffixIconSize;
  final CustomInputFieldOptions? options;
  final Duration duration;
  final TextStyle textStyle;
  final VoidCallback onTap;

  const _InputFieldHintText({
    required this.hintText,
    required this.isOptionalField,
    required this.isFieldEmpty,
    required this.textFieldSize,
    required this.prefixIconSize,
    required this.suffixIconSize,
    this.options,
    required this.duration,
    required this.textStyle,
    required this.onTap,
  });

  @override
  State<_InputFieldHintText> createState() => _InputFieldHintTextState();
}

class _InputFieldHintTextState extends State<_InputFieldHintText> {
  double _getHintTextSize() {
    final labelCollapsedPainter = TextPainter(
      text: TextSpan(
        text: widget.hintText + (widget.isOptionalField ? '*' : ''),
        style: widget.textStyle,
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: double.maxFinite);

    return labelCollapsedPainter.size.width;
  }

  @override
  Widget build(BuildContext context) {
    final borderWidth = Theme.of(context).inputDecorationTheme.border?.borderSide.width ?? 1.0;
    final defaultTopPosition = SizeConstants.defaultTextInputPadding.top + borderWidth;
    final defaultLeftPosition = widget.prefixIconSize > 0.0 ? widget.prefixIconSize : SizeConstants.defaultTextInputPadding.left;
    final defaultRightPosition = widget.suffixIconSize > 0.0 ? widget.suffixIconSize + 8.0 : SizeConstants.defaultTextInputPadding.right;

    final maxHintWidth = widget.textFieldSize - defaultLeftPosition - defaultRightPosition;
    final currentHintWidth = _getHintTextSize() + 2.0;
    final hintWidth = currentHintWidth > maxHintWidth ? maxHintWidth : currentHintWidth;

    return Positioned(
      top: defaultTopPosition,
      left: defaultLeftPosition,
      width: hintWidth > 0 ? hintWidth : null,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedOpacity(
          duration: widget.duration,
          opacity: widget.isFieldEmpty ? 1.0 : 0.0,
          child: CustomRichText(
            span: TextSpan(
              text: widget.hintText,
              children: [
                if (widget.isOptionalField)
                  TextSpan(
                    text: '*',
                    style: TextStyle(
                      height: 1.0,
                      color: ColorConstants.attentionColor(),
                    ),
                  ),
              ],
              style: widget.textStyle,
            ),
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}

enum CustomTextInputFieldType {
  scaffold,
  dialog,
}

class CustomInputFieldOptions {
  final CustomTextInputFieldType type;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? textStyle;
  final bool? isDense;
  final bool allowSpaces, allowUncommonSymbols;
  final bool withClearButton;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final int maxLength, maxLines;

  const CustomInputFieldOptions({
    this.type = CustomTextInputFieldType.scaffold,
    this.contentPadding,
    this.textStyle,
    this.isDense,
    this.allowSpaces = true,
    this.allowUncommonSymbols = false,
    this.withClearButton = true,
    this.maxLengthEnforcement,
    this.maxLength = 64,
    this.maxLines = 1,
  })  : assert(maxLength >= 0),
        assert(maxLines >= 1);
}