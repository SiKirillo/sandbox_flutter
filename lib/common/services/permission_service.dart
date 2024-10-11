part of '../common.dart';

class PermissionService {
  static Future<bool> isPhoneContactsPermissionGranted({BuildContext? context}) async {
    LoggerService.logTrace('PermissionService -> isPhoneContactsPermissionGranted()');
    PermissionStatus status = await Permission.contacts.status;

    if (status == PermissionStatus.denied) {
      if (context != null) {
        final isGranted = await DialogsUtil.showBottomSheetCustom(
          _showPhoneContractsInfoDialog(context),
          context: context,
        );

        if (isGranted != true) {
          return false;
        }
      }

      status = await Permission.contacts.request();
    }

    if (status != PermissionStatus.granted && status != PermissionStatus.limited) {
      if (context != null) {
        await DialogsUtil.showDialogCustom(
          CustomActionDialog(
            title: 'permissions.contacts.request.title'.tr(),
            content: 'permissions.contacts.request.subtitle'.tr(),
            cancelText: 'button.cancel'.tr(),
            actionText: 'button.open'.tr(),
            onCancel: () {
              Navigator.of(context).pop();
            },
            onAction: () {
              Navigator.of(context).pop();
              Future.delayed(StyleConstants.defaultAnimationDuration).then((_) {
                openAppSettings();
              });
            },
          ),
          context: context,
        );
      }
    }

    return status == PermissionStatus.granted || status == PermissionStatus.limited;
  }

  static Future<bool> isNotificationsPermissionGranted({BuildContext? context}) async {
    LoggerService.logTrace('PermissionService -> isNotificationsPermissionGranted()');
    PermissionStatus status = await Permission.notification.status;

    if (status == PermissionStatus.denied) {
      status = await Permission.notification.request();
    }

    if (status != PermissionStatus.granted && status != PermissionStatus.limited && status != PermissionStatus.permanentlyDenied) {
      if (context != null) {
        await DialogsUtil.showDialogCustom(
          CustomActionDialog(
            title: 'permissions.notifications.request.title'.tr(),
            content: 'permissions.notifications.request.subtitle'.tr(),
            cancelText: 'button.cancel'.tr(),
            actionText: 'button.open'.tr(),
            onCancel: () {
              Navigator.of(context).pop();
            },
            onAction: () {
              Navigator.of(context).pop();
              Future.delayed(StyleConstants.defaultAnimationDuration).then((_) {
                openAppSettings();
              });
            },
          ),
          context: context,
        );
      }
    }

    return status == PermissionStatus.granted || status == PermissionStatus.limited;
  }

  static Widget _showPhoneContractsInfoDialog(BuildContext context) {
    return DialogWrapper(
      labelPadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: ScrollableWrapper(
        options: ScrollableWrapperOptions(
          type: ScrollableWrapperType.dialog,
          padding: const EdgeInsets.only(
            top: 16.0,
            bottom: 40.0,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 110.0,
              child: SvgPicture.asset(
                'ImageConstants.icLabelContacts',
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            CustomText(
              text: 'permissions.contacts.info.title'.tr(),
              style: Theme.of(context).dialogTheme.titleTextStyle,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            const SizedBox(
              height: 8.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: CustomText(
                text: 'permissions.contacts.info.subtitle'.tr(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  height: 16.0 / 12.0,
                ),
                textAlign: TextAlign.center,
                maxLines: 5,
              ),
            ),
            const SizedBox(
              height: 24.0,
            ),
            Row(
              children: [
                Expanded(
                  child: CustomTextButton(
                    content: 'permissions.contacts.info.button_cancel'.tr(),
                    onTap: () {
                      Navigator.of(context).pop(false);
                    },
                    options: CustomTextButtonOptions(
                      type: CustomButtonType.attention,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: CustomTextButton(
                    content: 'permissions.contacts.info.button_continue'.tr(),
                    onTap: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}