part of '../common.dart';

class PermissionService {
  Future<bool> get isCameraGranted async {
    final status = await Permission.camera.status;
    return status == PermissionStatus.granted || status == PermissionStatus.limited;
  }

  Future<bool> get isLocationGranted async {
    final serviceStatus = await Permission.location.serviceStatus;
    final status = await Permission.location.status;
    return serviceStatus == ServiceStatus.enabled && (status == PermissionStatus.granted || status == PermissionStatus.limited);
  }

  Future<bool> requestCameraPermission({BuildContext? context}) async {
    LoggerService.logTrace('PermissionService -> requestCameraPermission()');
    final response = await locator<InAppDialogsProvider>().showBottomSheetCustom(
      child: _CameraPermissionBottomSheet(),
    );

    if (response != true) {
      return false;
    }

    PermissionStatus status = await Permission.camera.status;
    if (status == PermissionStatus.denied) {
      status = await Permission.camera.request();
    }

    if (status != PermissionStatus.granted && status != PermissionStatus.limited) {
      await locator<InAppDialogsProvider>().showDialogCustom(
        child: CustomActionDialog(
          title: 'permissions.camera.camera_disabled.label'.tr(),
          content: 'permissions.camera.camera_disabled.description'.tr(),
          cancelText: 'button.cancel'.tr(),
          actionText: 'permissions.camera.camera_disabled.button'.tr(),
          onCancel: () {},
          onAction: () {
            Future.delayed(OtherConstants.defaultAnimationDuration).then((_) {
              openAppSettings();
            });
          },
        ),
        context: context,
      );
    }

    return status == PermissionStatus.granted || status == PermissionStatus.limited;
  }

  Future<bool> requestLocationPermission({BuildContext? context}) async {
    LoggerService.logTrace('PermissionService -> requestLocationPermission()');
    /// Without location package
    // ServiceStatus serviceStatus = await Permission.location.serviceStatus;
    // if (serviceStatus != ServiceStatus.enabled) {
    //   final response = await DialogsUtil.showBottomSheetCustom(
    //     context: context,
    //     child: _LocationServiceDisabledBottomSheet(),
    //   );
    //
    //   serviceStatus = await Permission.location.serviceStatus;
    //   if (response != true || serviceStatus != ServiceStatus.enabled) {
    //     return false;
    //   }
    // }

    /// With location package
    PermissionStatus status = await Permission.location.status;

    /// Show request location custom dialog if permission hasn't been requested or has been denied
    if (status == PermissionStatus.denied || status == PermissionStatus.permanentlyDenied) {
      final response = await locator<InAppDialogsProvider>().showBottomSheetCustom(
        child: _LocationPermissionBottomSheet(),
      );

      if (response == true) {
        /// Show dialog with "Settings" button if permission has been denied permanently
        await _checkIfPermissionDenied(status, context);
        status = await Permission.location.request();
      } else {
        return false;
      }
    }

    bool isLocationPermissionProvided = status == PermissionStatus.granted || status == PermissionStatus.limited;
    if (isLocationPermissionProvided) {
      bool isServiceEnabled = await locator<LocationService>().isLocationServiceGranted;
      if (!isServiceEnabled) {
        isServiceEnabled = await locator<LocationService>().requestLocationServicePermission();
        if (!isServiceEnabled) {
          return false;
        }
      }
    }

    return isLocationPermissionProvided;
  }

  Future<void> _checkIfPermissionDenied(PermissionStatus status, BuildContext? context) async {
    if (status == PermissionStatus.permanentlyDenied) {
      await locator<InAppDialogsProvider>().showDialogCustom(
        child: CustomActionDialog(
          title: 'permissions.location.location_disabled.label'.tr(),
          content: 'permissions.location.location_disabled.description'.tr(),
          cancelText: 'button.cancel'.tr(),
          actionText: 'permissions.location.location_disabled.button'.tr(),
          onCancel: () {},
          onAction: () {
            Future.delayed(OtherConstants.defaultAnimationDuration).then((_) {
              openAppSettings();
            });
          },
        ),
        context: context,
      );
    }
  }
}

/// Permission.camera
class _CameraPermissionBottomSheet extends StatelessWidget {
  const _CameraPermissionBottomSheet();

  void _onOpenPermissionHandler() {
    AppRouter.configs.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return DialogWrapper(
      options: DialogWrapperOptions(
        contentPadding: EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 24.0),
        withCloseButton: true,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            ImageConstants.icPermissionLocation,
            height: 80.0,
            width: 80.0,
          ),
          SizedBox(height: 32.0),
          CustomText(
            text: 'permissions.camera.camera_not_granted.label'.tr(),
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
            maxLines: 3,
          ),
          SizedBox(height: 8.0),
          CustomText(
            text: 'permissions.camera.camera_not_granted.description'.tr(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: ColorConstants.textBlack().withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
            maxLines: 10,
          ),
          SizedBox(height: 32.0),
          CustomButton(
            content: 'button.continue'.tr(),
            onTap: _onOpenPermissionHandler,
          ),
        ],
      ),
    );
  }
}

/// Permission.location
class _LocationServiceDisabledBottomSheet extends StatefulWidget {
  const _LocationServiceDisabledBottomSheet();

  @override
  State<_LocationServiceDisabledBottomSheet> createState() => _LocationServiceDisabledBottomSheetState();
}

class _LocationServiceDisabledBottomSheetState extends State<_LocationServiceDisabledBottomSheet> {
  bool _isRequestInProgress = false;

  Future<void> _onOpenAppSettingsHandler() async {
    if (_isRequestInProgress) return;
    _isRequestInProgress = true;

    await Future.delayed(OtherConstants.defaultAnimationDuration);
    await openAppSettings();
    await Future.delayed(OtherConstants.defaultAnimationDuration);
    AppRouter.configs.pop(true);

    _isRequestInProgress = false;
  }

  void _onCancelHandler() {
    AppRouter.configs.pop(false);
  }

  @override
  Widget build(BuildContext context) {
    return DialogWrapper(
      options: DialogWrapperOptions(
        contentPadding: EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 24.0),
        withCloseButton: true,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            ImageConstants.icPermissionLocation,
            height: 80.0,
            width: 80.0,
          ),
          SizedBox(height: 32.0),
          CustomText(
            text: 'permissions.location.location_disabled.label'.tr(),
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
            maxLines: 3,
          ),
          SizedBox(height: 8.0),
          CustomText(
            text: 'permissions.location.location_disabled.description'.tr(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: ColorConstants.textBlack().withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
            maxLines: 10,
          ),
          SizedBox(height: 32.0),
          CustomButton(
            content: 'permissions.location.location_disabled.button'.tr(),
            onTap: _onOpenAppSettingsHandler,
          ),
          SizedBox(height: 8.0),
          CustomButton(
            content: 'button.cancel'.tr(),
            onTap: _onCancelHandler,
            options: CustomButtonOptions(
              type: CustomButtonType.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationPermissionBottomSheet extends StatelessWidget {
  const _LocationPermissionBottomSheet();

  void _onOpenPermissionHandler() {
    AppRouter.configs.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return DialogWrapper(
      options: DialogWrapperOptions(
        contentPadding: EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 24.0),
        withCloseButton: true,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            ImageConstants.icPermissionLocation,
            height: 80.0,
            width: 80.0,
          ),
          SizedBox(height: 32.0),
          CustomText(
            text: 'permissions.location.location_not_granted.label'.tr(),
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
            maxLines: 3,
          ),
          SizedBox(height: 8.0),
          CustomText(
            text: 'permissions.location.location_not_granted.description'.tr(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: ColorConstants.textBlack().withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
            maxLines: 10,
          ),
          SizedBox(height: 32.0),
          CustomButton(
            content: 'button.continue'.tr(),
            onTap: _onOpenPermissionHandler,
          ),
          SizedBox(height: 8.0),
          CustomButton(
            content: 'button.prohibit'.tr(),
            options: CustomButtonOptions(type: CustomButtonType.white),
            onTap: () {
              AppRouter.configs.pop();
            },
          ),
        ],
      ),
    );
  }
}