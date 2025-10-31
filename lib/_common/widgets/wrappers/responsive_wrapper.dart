part of '../../common.dart';

class ResponsiveWrapper extends StatelessWidget {
  final bool isResponsive;
  final Widget? web;
  final Widget? tablet;
  final Widget? tabletLandscape;
  final Widget? tabletPortrait;
  final Widget mobile;

  const ResponsiveWrapper({
    super.key,
    this.isResponsive = true,
    this.web,
    this.tablet,
    this.tabletLandscape,
    this.tabletPortrait,
    required this.mobile,
  });

  static double responsiveSize(BuildContext context, double mobileSize, {double? tabletSize, double? webSize}) {
    if (SizeConstants.isWeb(context: context)) {
      return webSize ?? tabletSize ?? mobileSize;
    }

    if (SizeConstants.isTablet(context: context)) {
      return tabletSize ?? mobileSize;
    }

    return mobileSize;
  }

  static double responsivePadding(BuildContext context, {double multiplier = 1.0}) {
    final size = MediaQuery.sizeOf(context).width;
    final ratio = SizeConstants.isWeb(context: context) ? 0.32 : SizeConstants.isTablet(context: context) ? 0.24 : 0.0;
    return size * ratio * multiplier;
  }

  @override
  Widget build(BuildContext context) {
    final widthScreenPadding = ResponsiveWrapper.responsivePadding(context);
    final responsivePadding = EdgeInsets.only(
      left: isResponsive ? widthScreenPadding : 0.0,
      right: isResponsive ? widthScreenPadding : 0.0,
    );

    if (SizeConstants.isWeb(context: context) && web != null) {
      return Padding(
        padding: responsivePadding,
        child: web!,
      );
    }

    if (SizeConstants.isTabletLandscape(context: context) && (tabletLandscape != null || tablet != null)) {
      return Padding(
        padding: responsivePadding,
        child: tabletLandscape ?? tablet,
      );
    }

    if (SizeConstants.isTabletPortrait(context: context) && (tabletPortrait != null || tablet != null)) {
      return Padding(
        padding: responsivePadding,
        child: tabletPortrait ?? tablet,
      );
    }

    return Padding(
      padding: responsivePadding,
      child: mobile,
    );
  }
}
