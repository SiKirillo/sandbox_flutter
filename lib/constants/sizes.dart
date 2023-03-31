import 'package:flutter/material.dart';

import '../features/screen_builder.dart';

class SizeConstants {
  static const defaultPadding = 24.0;
  static const defaultButtonHeight = 52.0;
  static const defaultTextInputSize = 52.0;
  static const defaultIconSize = 24.0;
  static const defaultListTileSize = 64.0;
  static const defaultAppBarSize = 56.0;
  static const defaultNavigationBarSize = 54.0;

  static const defaultSmallDeviceSize = 375.0;
  static const defaultTabletDeviceSize = 540.0;

  /// iPhone 6 - 375px, iPhone 13 - 390px
  static bool isSmallDevice({BuildContext? context}) {
    if (ScreenBuilder.globalKey.currentContext == null && context == null) {
      return false;
    }

    return MediaQuery.of(context ?? ScreenBuilder.globalKey.currentContext!).size.shortestSide <= defaultSmallDeviceSize;
  }

  static bool isTabletDevice({BuildContext? context}) {
    if (ScreenBuilder.globalKey.currentContext == null && context == null) {
      return false;
    }

    return MediaQuery.of(context ?? ScreenBuilder.globalKey.currentContext!).size.shortestSide >= defaultTabletDeviceSize;
  }

  /// iPhone 6 - 2.0, iPhone 13 - 3.0
  static double convertDpToPx(double dp, {BuildContext? context}) {
    if (ScreenBuilder.globalKey.currentContext == null && context == null) {
      return 0.0;
    }

    return MediaQuery.of(context ?? ScreenBuilder.globalKey.currentContext!).devicePixelRatio * dp;
  }
}
