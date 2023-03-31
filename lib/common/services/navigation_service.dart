import 'dart:io';

import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

/// This service handle pages swipe animation and navigation in the app
class NavigationService {
  static PageRoute getPageRoute(
    Widget screen, {
    RouteSettings? settings,
    bool canSwipe = true,
  }) {
    if (Platform.isAndroid) {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => screen,
      );
    }

    return SwipeablePageRoute(
      canSwipe: canSwipe,
      canOnlySwipeFromEdge: true,
      settings: settings,
      builder: (context) => screen,
    );
  }
}
