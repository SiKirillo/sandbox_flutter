part of '../../common.dart';

class CustomTextButton extends StatelessWidget {
  final dynamic content;
  final VoidCallback onTap;
  final bool isSlim;
  final bool isBlocked;
  final bool isProcessing;
  final CustomTextButtonOptions options;

  const CustomTextButton({
    super.key,
    required this.content,
    required this.onTap,
    this.isSlim = false,
    this.isBlocked = false,
    this.isProcessing = false,
    this.options = const CustomTextButtonOptions(),
  })  : assert(content is Widget || content is String);

  static TextStyle? getTextButtonStyle({
    required CustomButtonType type,
    required BuildContext context,
    TextStyle? textStyle,
    bool isBlocked = false,
  }) {
    late final Color color;
    switch (type) {
      case CustomButtonType.primary:
        color = isBlocked
            ? (textStyle?.color ?? ColorConstants.buttonTextPrimaryColor()).withOpacity(0.5)
            : textStyle?.color ?? ColorConstants.buttonTextPrimaryColor();

      case CustomButtonType.attention:
        color = textStyle?.color ?? ColorConstants.buttonTextPrimaryColor();
    }

    return (textStyle ?? Theme.of(context).textTheme.displayMedium)?.copyWith(
      color: textStyle?.color ?? color,
    );
  }

  static BoxDecoration? getButtonDecoration({
    required CustomButtonType type,
    required BuildContext context,
    BoxDecoration? buttonStyle,
    bool isBlocked = false,
  }) {
    late final Color color;
    late final double borderRadius;

    switch (type) {
      case CustomButtonType.primary:
        color = isBlocked
            ? ColorConstants.buttonDisableColor()
            : ColorConstants.buttonColor();
        borderRadius = 25.0;

      case CustomButtonType.attention:
        color = ColorConstants.buttonAttentionColor();
        borderRadius = 19.0;
    }

    return (buttonStyle ?? const BoxDecoration()).copyWith(
      color: buttonStyle?.color ?? color,
      borderRadius: buttonStyle?.borderRadius ?? BorderRadius.all(Radius.circular(borderRadius)),
    );
  }

  static Color getButtonSplashColor({
    required CustomButtonType type,
    required BuildContext context,
    Color? splashColor,
    bool isBlocked = false,
  }) {
    switch (type) {
      case CustomButtonType.primary:
        return splashColor ?? ColorConstants.buttonSplashPrimaryColor();

      case CustomButtonType.attention:
        return splashColor ?? ColorConstants.buttonSplashPrimaryColor();
    }
  }

  Widget _buildContentWidget(BuildContext context) {
    return content is Widget ? content : CustomText(
      text: content,
      maxLines: 1,
      style: CustomTextButton.getTextButtonStyle(
        type: options.type,
        context: context,
        textStyle: options.textStyle,
        isBlocked: isBlocked,
      ),
      isVerticalCentered: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final customTextStyle = CustomTextButton.getTextButtonStyle(
      type: options.type,
      context: context,
      textStyle: options.textStyle,
      isBlocked: isBlocked,
    );

    final customButtonDecoration = CustomTextButton.getButtonDecoration(
      type: options.type,
      context: context,
      buttonStyle: options.buttonStyle,
      isBlocked: isBlocked,
    );

    final customSplashColor = CustomTextButton.getButtonSplashColor(
      type: options.type,
      context: context,
      splashColor: options.splashColor,
      isBlocked: isBlocked,
    );

    return AbsorbPointer(
      absorbing: isBlocked,
      child: Container(
        height: options.height,
        width: isSlim ? null : options.width ?? double.maxFinite,
        decoration: customButtonDecoration,
        child: ClipRRect(
          borderRadius: customButtonDecoration?.borderRadius ?? BorderRadius.zero,
          child: TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              padding: options.padding,
              foregroundColor: customSplashColor,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: _buildContentWidget(context),
                ),
                AnimatedOpacity(
                  duration: StyleConstants.defaultAnimationDuration,
                  curve: Curves.easeInCubic,
                  opacity: isProcessing ? 1.0 : 0.0,
                  child: AnimatedContainer(
                    duration: StyleConstants.defaultAnimationDuration,
                    curve: Curves.easeInCubic,
                    width: isProcessing ? 16.0 : 0.0,
                    margin: EdgeInsets.only(
                      left: isProcessing ? 8.0 : 0.0,
                    ),
                    child: CustomProgressIndicator.simple(
                      size: 16.0,
                      color: customTextStyle?.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum CustomButtonType {
  primary,
  attention,
}

class CustomTextButtonOptions {
  final double height;
  final double? width;
  final EdgeInsets? padding;
  final BoxDecoration? buttonStyle;
  final TextStyle? textStyle;
  final Color? splashColor;
  final CustomButtonType type;

  const CustomTextButtonOptions({
    this.height = SizeConstants.defaultButtonHeight,
    this.width,
    this.padding = const EdgeInsets.symmetric(
      vertical: SizeConstants.defaultPadding * 0.5,
      horizontal: SizeConstants.defaultPadding,
    ),
    this.buttonStyle,
    this.textStyle,
    this.splashColor,
    this.type = CustomButtonType.primary,
  }) :  assert(height >= 0),
        assert(width == null || width >= 0);
}