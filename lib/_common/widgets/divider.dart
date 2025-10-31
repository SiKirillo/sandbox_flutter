part of '../common.dart';

class CustomDivider extends StatelessWidget {
  final double size, thickness, indent, endIndent;
  final Color? color;

  const CustomDivider({
    super.key,
    this.size = 1.0,
    this.thickness = 1.0,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.color,
  }) : assert(size >= 0 && thickness >= 0 && indent >= 0 && endIndent >= 0);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: size,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: color ?? Theme.of(context).dividerTheme.color,
    );
  }
}
