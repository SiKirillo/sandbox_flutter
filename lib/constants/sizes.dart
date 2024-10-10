part of '../common/common.dart';

class SizeConstants {
  static const defaultPadding = 16.0;
  static const defaultButtonHeight = 50.0;
  static const defaultIconSize = 24.0;
  static const defaultListTileSize = 64.0;
  static const defaultAppBarSize = 64.0;
  static const defaultNavigationBarSize = 60.0;

  static const defaultSmallDeviceSize = 375.0;
  static const defaultTabletDeviceSize = 540.0;
  static const defaultWebDeviceSize = 850.0;

  static const defaultTextInputPadding = EdgeInsets.only(
    top: 14.0,
    bottom: 14.0,
    left: 16.0,
    right: 8.0,
  );

  /// iPhone 6 - 375px, iPhone 13 - 390px
  static bool isSmallDevice({required BuildContext context}) {
    return MediaQuery.of(context).size.width <= defaultSmallDeviceSize;
  }

  static bool isTabletDevice({required BuildContext context}) {
    return MediaQuery.of(context).size.width >= defaultTabletDeviceSize;
  }

  static bool isWebDevice({required BuildContext context}) {
    return MediaQuery.of(context).size.width >= defaultWebDeviceSize;
  }

  /// iPhone 6 - 2.0, iPhone 13 - 3.0
  static double convertDpToPx(double dp, {required BuildContext context}) {
    return MediaQuery.of(context).devicePixelRatio * dp;
  }
}
