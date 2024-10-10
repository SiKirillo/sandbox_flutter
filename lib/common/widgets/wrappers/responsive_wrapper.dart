part of '../../common.dart';

class ResponsiveWrapper extends StatelessWidget {
  final bool isResponsive;
  final bool withNavigationRail;
  final Widget? web;
  final Widget? tablet;
  final Widget mobile;

  const ResponsiveWrapper({
    super.key,
    this.isResponsive = true,
    this.withNavigationRail = false,
    this.web,
    this.tablet,
    required this.mobile,
  });

  static double responsiveSize(BuildContext context, double mobileSize, {double? tabletSize, double? webSize}) {
    if (SizeConstants.isWebDevice(context: context)) {
      return webSize ?? tabletSize ?? mobileSize;
    }

    if (SizeConstants.isTabletDevice(context: context)) {
      return tabletSize ?? mobileSize;
    }

    return mobileSize;
  }

  static double responsivePadding(BuildContext context, {double increasingRatio = 1.0}) {
    final size = MediaQuery.of(context).size.width;
    final ratio = SizeConstants.isWebDevice(context: context) ? 0.2 : SizeConstants.isTabletDevice(context: context) ? 0.1 : 0.0;
    return size * ratio * increasingRatio;
  }

  @override
  Widget build(BuildContext context) {
    final isNeedAdditionalLeftPadding = withNavigationRail && SizeConstants.isTabletDevice(context: context);
    final widthScreenPadding = ResponsiveWrapper.responsivePadding(context);
    final padding = EdgeInsets.only(
      left: isResponsive ? math.max(isNeedAdditionalLeftPadding ? SizeConstants.defaultNavigationBarSize + 20.0 : widthScreenPadding, widthScreenPadding) : 0.0,
      right: isResponsive ? widthScreenPadding : 0.0,
    );

    if (SizeConstants.isWebDevice(context: context) && web != null) {
      return Padding(
        padding: padding,
        child: web!,
      );
    }

    if (SizeConstants.isTabletDevice(context: context) && tablet != null) {
      return Padding(
        padding: padding,
        child: tablet!,
      );
    }

    return Padding(
      padding: padding,
      child: mobile,
    );
  }
}
