import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../common.dart';
import '../../../services/logger/logger_service.dart';

part 'in_app_overlay_placeholder.dart';

class InAppOverlayProvider {
  late final GlobalKey<NavigatorState> _key;
  OverlayEntry? _overlay;

  void init(GlobalKey<NavigatorState> key) {
    LoggerService.logTrace('InAppOverlayProvider -> init()');
    _key = key;
  }

  void show({BuildContext? context, String? text}) {
    LoggerService.logTrace('InAppOverlayProvider -> show()');
    if (_key.currentState == null && context == null) {
      LoggerService.logWarning('InAppOverlayProvider -> show(): build state or context is null');
    }

    _overlay = OverlayEntry(
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
          child: ColoredBox(
            color: ColorConstants.overlay(),
            child: Center(
              child: InAppOverlayPlaceholder(text: text),
            ),
          ),
        );
      },
    );

    if (context != null) {
      Overlay.of(context).insert(_overlay!);
    } else {
      _key.currentState!.overlay!.insert(_overlay!);
    }
  }

  void hide() {
    LoggerService.logTrace('InAppOverlayProvider -> hide()');
    if (_overlay == null) return;
    _overlay!.remove();
    _overlay!.dispose();
    _overlay = null;
  }
}
