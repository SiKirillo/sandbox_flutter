part of '../../common.dart';

class CustomProgressIndicator extends StatelessWidget {
  final double iconSize;
  final double indicatorSize;
  final Color? iconColor;
  final double? indicatorValue;
  final Color? indicatorColor;
  final bool withShadow;

  const CustomProgressIndicator({
    super.key,
    this.iconSize = 40.0,
    this.indicatorSize = 16.0,
    this.iconColor,
    this.indicatorValue,
    this.indicatorColor,
    this.withShadow = true,
  }) : assert(iconSize >= 0.0 && indicatorSize >= 0.0);

  static Widget simple({double? size, double? value, Color? color}) {
    return SizedBox.square(
      dimension: size ?? 16.0,
      child: CircularProgressIndicator(
        value: value,
        color: color ?? ColorConstants.progressIndicator(),
        strokeWidth: 2.5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: iconSize,
      width: iconSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: iconColor ?? ColorConstants.progressIndicatorBG(),
        boxShadow: [
          if (withShadow)
            BoxShadow(
              offset: Offset(0.0, iconSize * 0.25),
              blurRadius: iconSize * 0.5,
              color: ColorConstants.progressIndicatorShadow(),
            ),
        ],
      ),
      child: Center(
        child: CustomProgressIndicator.simple(
          size: indicatorSize,
          value: indicatorValue,
          color: indicatorColor,
        ),
      ),
    );
  }
}
