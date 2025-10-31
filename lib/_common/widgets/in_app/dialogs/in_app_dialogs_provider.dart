import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../common.dart';
import '../../../services/logger/logger_service.dart';

class InAppDialogsProvider {
  late final GlobalKey<NavigatorState> _key;

  void init(GlobalKey<NavigatorState> key) {
    LoggerService.logTrace('InAppDialogsProvider -> init()');
    _key = key;
  }

  Future<T?> showBottomSheetCustom<T>({
    required Widget child,
    BuildContext? context,
    bool withBarrierColor = true,
    bool withBlur = true,
    bool isScrollable = false,
    bool withSafeArea = false,
  }) async {
    LoggerService.logTrace('InAppDialogsProvider -> showBottomSheet()');
    final buildContext = context ?? _key.currentContext;
    if (buildContext == null) {
      LoggerService.logWarning('InAppDialogsProvider -> showBottomSheet(): build context is null');
    }

    return await showModalBottomSheet<T>(
      constraints: BoxConstraints(
        maxWidth: double.maxFinite,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.0),
        ),
      ),
      barrierColor: withBarrierColor ? null : ColorConstants.transparent,
      backgroundColor: ColorConstants.transparent,
      isScrollControlled: true,
      enableDrag: isScrollable,
      useRootNavigator: true,
      context: buildContext!,
      builder: (_) {
        final bottomSheet = Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewPaddingOf(buildContext).bottom,
          ),
          margin: EdgeInsets.only(
            top: MediaQuery.viewPaddingOf(buildContext).top,
          ),
          decoration: BoxDecoration(
            color: Theme.of(buildContext).bottomSheetTheme.backgroundColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24.0),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24.0),
            ),
            child: SafeArea(
              bottom: withSafeArea,
              child: child,
            ),
          ),
        );

        if (withBlur) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: bottomSheet,
          );
        }

        return bottomSheet;
      },
    );
  }

  Future<T?> showDialogCustom<T>({
    required Widget child,
    BuildContext? context,
    bool withBarrierColor = true,
    bool withBlur = true,
  }) async {
    LoggerService.logTrace('InAppDialogsProvider -> showDialog()');
    final buildContext = context ?? _key.currentContext;
    if (buildContext == null) {
      LoggerService.logWarning('InAppDialogsProvider -> showDialog(): build context is null');
    }

    return await showDialog<T>(
      barrierColor: withBarrierColor ? null : ColorConstants.transparent,
      useRootNavigator: true,
      context: buildContext!,
      builder: (_) {
        if (withBlur) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: child,
          );
        }

        return child;
      },
    );
  }
}
