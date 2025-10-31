part of '../common.dart';

class CustomDropdownMenu<T> extends StatefulWidget {
  final List<T> items;
  final T? value;
  final String? hintText, errorText;
  final ValueChanged<T?>? onChanged;
  final String Function(T)? valueFormatter;
  final CustomDropdownOptions options;
  final bool isExpanded;
  final bool isDisabled;

  const CustomDropdownMenu({
    super.key,
    required this.items,
    this.value,
    this.hintText,
    this.errorText,
    this.onChanged,
    this.valueFormatter,
    this.options = const CustomDropdownOptions(),
    this.isExpanded = true,
    this.isDisabled = false,
  });

  @override
  State<CustomDropdownMenu<T>> createState() => _CustomDropdownMenuState<T>();
}

class _CustomDropdownMenuState<T> extends State<CustomDropdownMenu<T>> {
  bool _isExpanded = false;

  void _onChangedHandler(T? value) {
    if (widget.onChanged == null) return;
    widget.onChanged!(value);
  }

  void _onMenuStateHandler(bool value) {
    if (_isExpanded == value) return;
    setState(() {
      _isExpanded = value;
    });
  }

  String _valueToStringFormatter(T? value) {
    if (widget.valueFormatter != null && value != null) {
      return widget.valueFormatter!(value);
    }

    return value.toString();
  }

  Color _getBorderColor() {
    /// On disabled
    if (widget.isDisabled) {
      return ColorConstants.dropdownBorder();
    }

    /// On error
    if (widget.errorText != null) {
      return ColorConstants.dropdownBorderError();
    }

    /// On focused
    if (_isExpanded) {
      return ColorConstants.dropdownBorderFocused();
    }

    /// Default
    return ColorConstants.dropdownBorder();
  }

  Color _getIconColor() {
    /// On disabled
    if (widget.isDisabled) {
      return ColorConstants.dropdownIconDisable();
    }

    return ColorConstants.dropdownIconActive();
  }

  TextStyle _getTextStyle() {
    final textStyle = Theme.of(context).inputDecorationTheme.labelStyle!.copyWith(
      color: ColorConstants.dropdownText(),
      decorationThickness: 0.0,
    );

    /// On disabled
    if (widget.isDisabled) {
      return textStyle.copyWith(
        color: ColorConstants.dropdownTextDisable(),
      );
    }

    /// On empty value
    if (widget.value == null) {
      return textStyle.copyWith(
        color: ColorConstants.dropdownTextHint(),
      );
    }

    return textStyle;
  }

  BoxDecoration _getButtonDecoration(BuildContext context) {
    return widget.options.decoration ?? BoxDecoration(
      color: ColorConstants.dropdownBG(),
      border: Border.all(
        width: 1.0,
        color: _getBorderColor(),
      ),
      borderRadius: widget.options.borderRadius,
    );
  }

  BoxDecoration _getDropdownDecoration(BuildContext context) {
    return widget.options.dropdownDecoration ?? BoxDecoration(
      color: ColorConstants.dropdownItemBG(),
      borderRadius: widget.options.dropdownBorderRadius,
      boxShadow: [
        BoxShadow(
          color: Color(0xFF000000).withValues(alpha: 0.12),
          offset: Offset(0.0, 8.0),
          blurRadius: 12.0,
        ),
      ],
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 12.0,
      ),
      decoration: BoxDecoration(
        color: ColorConstants.textFieldTextErrorBG(),
        borderRadius: BorderRadius.all(Radius.circular(6.0)),
      ),
      child: AnimatedDefaultTextStyle(
        duration: Duration.zero,
        style: Theme.of(context).inputDecorationTheme.errorStyle!.copyWith(
          fontSize: 11.0,
          fontWeight: FontWeight.w500,
          height: 14.0 / 11.0,
          color: ColorConstants.inAppToastText(),
        ),
        child: CustomText(
          text: widget.errorText!,
          maxLines: Theme.of(context).inputDecorationTheme.errorMaxLines,
          isVerticalCentered: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: widget.isDisabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonHideUnderline(
            child: DropdownButton2<T>(
              value: widget.value,
              items: widget.items.map((item) {
                return DropdownMenuItem<T>(
                  value: item,
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    text: widget.valueFormatter!(item).toString(),
                    style: Theme.of(context).inputDecorationTheme.hintStyle,
                  ),
                );
              }).toList(),
              onChanged: _onChangedHandler,
              onMenuStateChange: _onMenuStateHandler,
              customButton: Container(
                height: widget.options.height,
                width: widget.options.width,
                padding: widget.options.padding,
                decoration: _getButtonDecoration(context),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomText(
                        text: widget.value != null
                            ? _valueToStringFormatter(widget.value)
                            : (widget.hintText ?? ''),
                        style: _getTextStyle(),
                        isVerticalCentered: false,
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    SvgPicture.asset(
                      ImageConstants.icDropDown,
                      height: 16.0,
                      width: 16.0,
                      color: _getIconColor(),
                    ),
                  ],
                ),
              ),
              buttonStyleData: ButtonStyleData(
                decoration: _getButtonDecoration(context),
              ),
              dropdownStyleData: DropdownStyleData(
                width: widget.options.width,
                padding: widget.options.dropdownPadding,
                decoration: _getDropdownDecoration(context),
                elevation: 0,
              ),
              menuItemStyleData: MenuItemStyleData(
                height: widget.options.itemHeight,
                padding: widget.options.itemPadding,
                overlayColor: WidgetStateProperty.all(widget.options.splashColor),
              ),
              alignment: Alignment.centerLeft,
              isExpanded: widget.isExpanded,
              isDense: true,
            ),
          ),
          if (widget.errorText != null && !widget.isDisabled) ...[
            SizedBox(
              height: 6.0,
            ),
            _buildErrorWidget(),
          ],
        ],
      ),
    );
  }
}

class CustomDropdownOptions {
  final double height, itemHeight;
  final double? width;
  final EdgeInsets padding, dropdownPadding, itemPadding;
  final BorderRadiusGeometry borderRadius, dropdownBorderRadius;
  final BoxDecoration? decoration, dropdownDecoration;
  final Color? color, splashColor;

  const CustomDropdownOptions({
    this.height = 56.0,
    this.itemHeight = 56.0,
    this.width,
    this.padding = const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
    this.dropdownPadding = const EdgeInsets.fromLTRB(0.0, 6.0, 0.0, 6.0),
    this.itemPadding = const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.dropdownBorderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.decoration,
    this.dropdownDecoration,
    this.color,
    this.splashColor,
  });
}