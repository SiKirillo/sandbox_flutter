part of '../_common/common.dart';

class SizeConstants {
  static const defaultButtonHeight = 56.0;
  static const defaultButtonIconSize = 24.0;
  static const defaultAppBarSize = 64.0;
  static const defaultNavigationBarSize = 58.0;
  static const defaultTextInputPadding = EdgeInsets.fromLTRB(16.0, 19.0, 16.0, 19.0);
  static const defaultTextInputOtpPadding = EdgeInsets.fromLTRB(16.0, 23.0, 12.0, 15.0);
  static const defaultTextInputSearchPadding = EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 15.0);

  static const defaultSmallDeviceSize = 375.0;
  static const defaultTabletDeviceSize = 540.0;
  static const defaultWebDeviceSize = 850.0;

  /// iPhone 6 - 375px, iPhone 13 - 390px
  static bool isSmall({required BuildContext context}) {
    return MediaQuery.sizeOf(context).width <= defaultSmallDeviceSize;
  }

  static bool isMobile({required BuildContext context}) {
    return MediaQuery.sizeOf(context).width < defaultTabletDeviceSize;
  }

  static bool isTablet({required BuildContext context}) {
    return MediaQuery.sizeOf(context).width >= defaultTabletDeviceSize;
  }

  static bool isTabletPortrait({required BuildContext context}) {
    return isTablet(context: context) && MediaQuery.orientationOf(context) == Orientation.portrait;
  }

  static bool isTabletLandscape({required BuildContext context}) {
    return isTablet(context: context) && MediaQuery.orientationOf(context) == Orientation.landscape;
  }

  static bool isWeb({required BuildContext context}) {
    return MediaQuery.sizeOf(context).width >= defaultWebDeviceSize;
  }

  static bool isLandscape({required BuildContext context}) {
    return MediaQuery.orientationOf(context) == Orientation.landscape;
  }

  static bool isPortrait({required BuildContext context}) {
    return MediaQuery.orientationOf(context) == Orientation.portrait;
  }

  /// iPhone 6 - 2.0, iPhone 13 - 3.0
  static double convertDpToPx(double dp, {required BuildContext context}) {
    return MediaQuery.devicePixelRatioOf(context) * dp;
  }
}
