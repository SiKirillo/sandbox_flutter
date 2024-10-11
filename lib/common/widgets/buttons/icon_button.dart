part of '../../common.dart';

class CustomIconButton extends StatelessWidget {
  final dynamic icon;
  final VoidCallback onTap;
  final CustomIconButtonOptions options;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.options = const CustomIconButtonOptions(),
  }) : assert(icon is String || icon is Icon || icon is Image || icon is SvgPicture || icon is Widget);

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: options.size,
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: icon is Image || icon is Icon || icon is SvgPicture || icon is Widget ? icon : Image.asset(icon),
        color: options.color ?? Theme.of(context).iconTheme.color,
        highlightColor: options.highlightColor,
        splashColor: options.splashColor,
        splashRadius: options.size,
        onPressed: onTap,
      ),
    );
  }
}

class CustomIconButtonOptions {
  final double size;
  final Color? color;
  final Color? hoverColor, highlightColor, splashColor;

  const CustomIconButtonOptions({
    this.size = SizeConstants.defaultIconSize,
    this.color,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
  }) : assert(size >= 0);
}