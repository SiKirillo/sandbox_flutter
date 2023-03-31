import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../features/screen_builder.dart';

/// This utility gives you more control than basic [showBottomSheet] and [showDialog] methods
/// (you don't have to search all showDialog calls if you want to change something)
class DialogsUtil {
  static Future<T?> footprintShowBottomSheet<T>(
    Widget dialog, {
    BuildContext? context,
    bool withBarrierColor = true,
    bool withBackgroundColor = true,
  }) async {
    final dialogContext = context ?? ScreenBuilder.globalKey.currentContext;
    if (dialogContext == null) {
      return null;
    }

    return await showModalBottomSheet<T>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12.0),
        ),
      ),
      barrierColor: withBarrierColor ? null : ColorConstants.transparent,
      backgroundColor: withBackgroundColor ? null : ColorConstants.transparent,
      isScrollControlled: true,
      enableDrag: true,
      context: dialogContext,
      builder: (_) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(dialogContext).size.height -
                MediaQuery.of(dialogContext).viewPadding.vertical,
          ),
          child: dialog,
        );
      },
    );
  }

  static Future<T?> footprintShowDialog<T>(
    Widget dialog, {
    BuildContext? context,
    bool withBarrierColor = true,
  }) async {
    final dialogContext = context ?? ScreenBuilder.globalKey.currentContext;
    if (dialogContext == null) {
      return null;
    }

    return await showDialog<T>(
      barrierColor: withBarrierColor ? null : ColorConstants.transparent,
      context: dialogContext,
      builder: (_) => dialog,
    );
  }
}
