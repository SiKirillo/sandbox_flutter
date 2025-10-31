part of '../../common.dart';

class CustomButton extends StatelessWidget {
  final dynamic content;
  final VoidCallback onTap;
  final CustomButtonOptions options;
  final bool isExpanded;
  final bool isDisabled;

  const CustomButton({
    super.key,
    required this.content,
    required this.onTap,
    this.options = const CustomButtonOptions(),
    this.isExpanded = true,
    this.isDisabled = false,
  }) : assert(content is Widget || content is String);

  BoxDecoration _getButtonDecoration(BuildContext context) {
    return options.decoration ?? BoxDecoration(
      color: options.color ?? (isDisabled
          ? ColorConstants.buttonDisable()
          : ColorConstants.button(options.type)),
      borderRadius: options.borderRadius,
    );
  }

  Widget _buildContentWidget(BuildContext context) {
    if (content is String) {
      final textStyle = options.textStyle ?? Theme.of(context).textTheme.displayMedium?.copyWith(
        color: options.color ?? (isDisabled
            ? ColorConstants.buttonContentDisable()
            : ColorConstants.buttonContent(options.type)),
      );

      return CustomText(
        text: content,
        style: textStyle,
        maxLines: 1,
        isVerticalCentered: false,
      );
    }

    return content;
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isDisabled,
      child: Container(
        height: options.height,
        width: isExpanded ? double.maxFinite : options.width,
        constraints: options.constraints,
        decoration: _getButtonDecoration(context),
        child: TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            padding: options.padding,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            foregroundColor: options.splashColor ?? ColorConstants.buttonSplash(options.type),
            shape: RoundedRectangleBorder(
              borderRadius: options.borderRadius,
            ),
          ),
          child: _buildContentWidget(context),
        ),
      ),
    );
  }
}

enum CustomButtonType {
  blue,
  white,
  appbar,
}

class CustomButtonOptions {
  final double? height, width;
  final double? size;
  final BoxConstraints? constraints;
  final EdgeInsets padding;
  final BorderRadiusGeometry borderRadius;
  final BoxDecoration? decoration;
  final Color? color, splashColor;
  final TextStyle? textStyle;
  final CustomButtonType type;

  const CustomButtonOptions({
    this.height = SizeConstants.defaultButtonHeight,
    this.width,
    this.size = SizeConstants.defaultButtonIconSize,
    this.constraints,
    this.padding = const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
    this.borderRadius = const BorderRadius.all(Radius.circular(12.0)),
    this.decoration,
    this.color,
    this.splashColor,
    this.textStyle,
    this.type = CustomButtonType.blue,
  });
}
