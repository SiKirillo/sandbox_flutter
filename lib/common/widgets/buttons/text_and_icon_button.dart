part of '../../common.dart';

class CustomTextAndIconButton extends StatelessWidget {
  final Widget content;
  final VoidCallback onTap;
  final bool isSlim;
  final bool isBlocked;
  final CustomTextAndIconButtonOptions options;

  const CustomTextAndIconButton({
    super.key,
    required this.content,
    required this.onTap,
    this.isSlim = false,
    this.isBlocked = false,
    this.options = const CustomTextAndIconButtonOptions(),
  });

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isBlocked,
      child: Container(
        height: options.height,
        width: isSlim ? null : options.width ?? double.maxFinite,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          child: TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              padding: options.padding,
              foregroundColor: ColorConstants.buttonSplashPrimaryColor(),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}

class CustomTextAndIconButtonOptions {
  final double height;
  final double? width;
  final EdgeInsets? padding;

  const CustomTextAndIconButtonOptions({
    this.height = 40.0,
    this.width,
    this.padding = const EdgeInsets.all(4.0),
  }) :  assert(height >= 0),
        assert(width == null || width >= 0);
}