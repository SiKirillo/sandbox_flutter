part of '../../common.dart';

class CustomHyperlinkButton extends StatelessWidget {
  final dynamic content;
  final VoidCallback onTap;
  final CustomButtonOptions options;

  const CustomHyperlinkButton({
    super.key,
    required this.content,
    required this.onTap,
    this.options = const CustomButtonOptions(
      padding: EdgeInsets.all(2.0),
    ),
  }) : assert(content is Widget || content is String);

  Widget _buildContentWidget(BuildContext context) {
    if (content is String) {
      final textStyle = options.textStyle ?? Theme.of(context).textTheme.displaySmall?.copyWith(
        color: ColorConstants.buttonHyperlink(),
        decoration: TextDecoration.underline,
        decorationColor: ColorConstants.buttonHyperlink(),
      );

      return CustomText(
        text: content,
        style: textStyle,
        maxLines: 2,
        textAlign: TextAlign.center,
        isVerticalCentered: false,
      );
    }

    return content;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: options.padding,
        child: _buildContentWidget(context),
      ),
    );
  }
}
