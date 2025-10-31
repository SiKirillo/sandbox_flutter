part of '../../common.dart';

class CustomSmallButton extends StatelessWidget {
  final dynamic content;
  final VoidCallback onTap;
  final CustomButtonOptions options;
  final CustomSmallButtonType type;
  final bool isExpanded;
  final bool isDisabled;

  const CustomSmallButton({
    super.key,
    required this.content,
    required this.onTap,
    this.options = const CustomButtonOptions(
      height: 32.0,
      padding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    this.type = CustomSmallButtonType.transparent,
    this.isExpanded = false,
    this.isDisabled = false,
  }) : assert(content is Widget || content is String);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      content: content,
      onTap: onTap,
      options: CustomButtonOptions(
        height: options.height,
        width: options.width,
        constraints: options.constraints,
        padding: options.padding,
        borderRadius: options.borderRadius,
        decoration: options.decoration ?? BoxDecoration(
          color: options.color ?? (isDisabled
              ? ColorConstants.buttonSmallDisable()
              : ColorConstants.buttonSmall(type)),
          borderRadius: options.borderRadius,
        ),
        splashColor: options.splashColor ?? ColorConstants.buttonSmallSplash(type),
        textStyle: options.textStyle ?? Theme.of(context).textTheme.displayMedium?.copyWith(
          fontSize: 13.0,
          height: 16.0 / 13.0,
          color: ColorConstants.buttonSmallContent(type),
        ),
      ),
      isExpanded: isExpanded,
      isDisabled: isDisabled,
    );
  }
}

enum CustomSmallButtonType {
  transparent,
  blue,
  attention,
}
