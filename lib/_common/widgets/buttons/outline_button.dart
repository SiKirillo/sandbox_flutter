part of '../../common.dart';

class CustomOutlineButton extends StatelessWidget {
  final dynamic content;
  final VoidCallback onTap;
  final CustomButtonOptions options;
  final bool isExpanded;
  final bool isDisabled;

  const CustomOutlineButton({
    super.key,
    required this.content,
    required this.onTap,
    this.options = const CustomButtonOptions(),
    this.isExpanded = true,
    this.isDisabled = false,
  }) : assert(content is Widget || content is String);

  BoxDecoration _getButtonDecoration(BuildContext context) {
    return options.decoration ?? BoxDecoration(
      color: isDisabled
          ? ColorConstants.buttonTextDisable()
          : null,
      border: isDisabled
          ? null
          : Border.all(
              color: options.color ?? ColorConstants.buttonOutline() ,
            ),
      borderRadius: options.borderRadius,
    );
  }

  Widget _buildContentWidget(BuildContext context) {
    if (content is String) {
      final textStyle = options.textStyle ?? Theme.of(context).textTheme.displayMedium?.copyWith(
        color: isDisabled
            ? ColorConstants.buttonContentDisable()
            : options.color ?? ColorConstants.buttonContentBlue(),
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
            foregroundColor: options.splashColor ?? ColorConstants.buttonOutlineSplash(),
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
