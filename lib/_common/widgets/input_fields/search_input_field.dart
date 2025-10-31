part of '../../common.dart';

class CustomSearchInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? labelText, hintText;
  final Widget? prefixIcon, suffixIcon;
  final bool isDisabled, isAutofocused, isProcessing;
  final bool isOptionalField;
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

  const CustomSearchInputField({
    super.key,
    required this.controller,
    this.focusNode,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.isDisabled = false,
    this.isAutofocused = false,
    this.isProcessing = false,
    this.isOptionalField = false,
    this.keyboardType = TextInputType.text,
    this.inputAction = TextInputAction.search,
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
  State<CustomSearchInputField> createState() => _CustomSearchInputFieldState();
}

class _CustomSearchInputFieldState extends State<CustomSearchInputField> {
  late final FocusNode _focusNode;

  bool _isFocused = false;
  bool _isFieldEmpty = true;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
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

  TextStyle _getTextStyle() {
    final textStyle = Theme.of(context).inputDecorationTheme.labelStyle!.copyWith(
      fontSize: 13.0,
      fontWeight: FontWeight.w500,
      height: 16.0 / 13.0,
      color: ColorConstants.textBlack().withValues(alpha: 0.7),
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
      fontSize: 13.0,
      fontWeight: FontWeight.w500,
      height: 16.0 / 13.0,
      color: ColorConstants.textBlack().withValues(alpha: 0.7),
      decorationThickness: 0.0,
    );

    /// On disabled
    if (widget.isDisabled) {
      return textStyle.copyWith(
        color: ColorConstants.textFieldTextDisable(),
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
      fontSize: 13.0,
      fontWeight: FontWeight.w500,
      height: 16.0 / 13.0,
      decorationThickness: 0.0,
    );
  }

  Color _getIconColor({bool isProcessing = false}) {
    /// On disabled
    if (widget.isDisabled) {
      return ColorConstants.textFieldIconDisable();
    }

    /// On focused processing
    if (isProcessing && widget.isProcessing && _isFocused) {
      return ColorConstants.textFieldBorderFocused();
    }

    /// On focused & default
    return ColorConstants.textFieldIconActive();
  }

  InputBorder _getBorderStyle() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      borderSide: BorderSide(
        width: 1.0,
        color: _isFocused ? ColorConstants.textFieldBorderFocused() : ColorConstants.textFieldSearchBG(),
      ),
    );
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
    return Padding(
      padding: EdgeInsets.only(
        left: widget.options.prefixPadding.left,
        right: widget.options.prefixPadding.right,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomIconButton(
            content: SvgPicture.asset(
              ImageConstants.icSearch,
              height: 20.0,
              width: 20.0,
              colorFilter: ColorFilter.mode(_getIconColor(), BlendMode.srcIn),
            ),
            onTap: () {},
            options: CustomButtonOptions(
              size: 20.0,
              padding: EdgeInsets.zero,
            ),
            isDisabled: true,
          ),
          if (widget.prefixIcon != null) ...[
            SizedBox(width: 4.0),
            widget.prefixIcon!
          ],
        ],
      ),
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
          if (widget.isProcessing) ...[
            SizedBox(width: 4.0),
            CustomProgressIndicator.simple(
              size: 12.0,
              color: _getIconColor(isProcessing: true),
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
    return Focus(
      onFocusChange: _onFocusChangeHandler,
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
          contentPadding: SizeConstants.defaultTextInputSearchPadding,
          prefixIconConstraints: BoxConstraints(
            minHeight: SizeConstants.defaultButtonIconSize,
          ),
          suffixIconConstraints: BoxConstraints(
            minHeight: SizeConstants.defaultButtonIconSize,
          ),
          border: _getBorderStyle(),
          enabledBorder: _getBorderStyle(),
          focusedBorder: _getBorderStyle(),
          disabledBorder: _getBorderStyle(),
          fillColor: ColorConstants.textFieldSearchBG(),
        ),
        inputFormatters: [
          ...widget.formatters ?? [],
          if (!widget.options.allowSpaces)
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
          if (!widget.options.allowUncommonSymbols)
            UncommonSymbolsInputFormatter(),
          LengthLimitingTextInputFormatter(widget.options.maxLength),
        ],
        cursorColor: Theme.of(context).inputDecorationTheme.focusedBorder?.borderSide.color,
        cursorWidth: 1.0,
        cursorOpacityAnimates: !kIsWeb,
        maxLengthEnforcement: widget.options.maxLengthEnforcement,
        maxLines: widget.options.maxLines,
        autofillHints: widget.autofillHints,
        enabled: !widget.isDisabled,
        autofocus: widget.isAutofocused,
        onChanged: _onChangedHandler,
        onEditingComplete: widget.onEditingComplete,
        onFieldSubmitted: widget.onFieldSubmitted,
        onTap: widget.onTap,
      ),
    );
  }
}
