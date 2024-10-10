part of '../common.dart';

class DialogsUtil {
  static Future<T?> showBottomSheetCustom<T>(
    Widget dialog, {
    required BuildContext? context,
    bool withBarrierColor = true,
    bool withBackgroundColor = true,
  }) async {
    if (context == null) {
      return null;
    }

    return await showModalBottomSheet<T>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12.0),
        ),
      ),
      barrierColor: withBarrierColor ? null : ColorConstants.transparent,
      backgroundColor: ColorConstants.transparent,
      isScrollControlled: true,
      enableDrag: true,
      context: context,
      builder: (_) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).viewPadding.vertical,
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewPadding.bottom,
          ),
          decoration: BoxDecoration(
            color: withBackgroundColor
                ? Theme.of(context).bottomSheetTheme.backgroundColor
                : ColorConstants.transparent,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12.0),
            ),
          ),
          child: dialog,
        );
      },
    );
  }

  static Future<T?> showBottomSheetSettingsCustom<T>(
    Widget dialog, {
    required BuildContext? context,
    bool withBarrierColor = true,
  }) async {
    if (context == null) {
      return null;
    }

    return await showModalBottomSheet<T>(
      barrierColor: withBarrierColor ? null : ColorConstants.transparent,
      backgroundColor: ColorConstants.transparent,
      isScrollControlled: true,
      enableDrag: true,
      context: context,
      builder: (_) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).viewPadding.vertical,
          ),
          padding: EdgeInsets.only(
            top: 12.0,
            bottom: 12.0 + MediaQuery.of(context).viewPadding.bottom,
            left: 12.0,
            right: 12.0,
          ),
          child: dialog,
        );
      },
    );
  }

  static Future<T?> showDialogCustom<T>(
    Widget dialog, {
    required BuildContext? context,
    bool withBarrierColor = true,
  }) async {
    if (context == null) {
      return null;
    }

    return await showDialog<T>(
      barrierColor: withBarrierColor ? null : ColorConstants.transparent,
      context: context,
      builder: (_) => dialog,
    );
  }
}
