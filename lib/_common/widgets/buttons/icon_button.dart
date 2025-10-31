part of '../../common.dart';

class CustomIconButton extends StatelessWidget {
  final dynamic content;
  final VoidCallback onTap;
  final CustomButtonOptions options;
  final bool isDisabled;

  const CustomIconButton({
    super.key,
    required this.content,
    required this.onTap,
    this.options = const CustomButtonOptions(
      padding: EdgeInsets.zero,
    ),
    this.isDisabled = false,
  }) : assert(content is Icon || content is Image || content is SvgPicture || content is Widget);

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isDisabled,
      child: SizedBox.square(
        dimension: options.size,
        child: IconButton(
          icon: content,
          padding: options.padding,
          splashRadius: options.size,
          highlightColor: options.splashColor,
          onPressed: onTap,
        ),
      ),
    );
  }
}