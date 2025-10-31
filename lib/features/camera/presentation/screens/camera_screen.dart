part of '../../camera.dart';

class CameraScreen extends StatefulWidget {
  static const routePath = '/camera';

  final CameraSettingsOptions settings;

  const CameraScreen({
    super.key,
    this.settings = const CameraSettingsOptions(),
  });

  static DeviceOrientation predictDeviceOrientation(BuildContext context, Orientation orientation) {
    if (orientation == Orientation.landscape) {
      return MediaQuery.viewPaddingOf(context).right > 0.0 ? DeviceOrientation.landscapeRight : DeviceOrientation.landscapeLeft;
    }

    return DeviceOrientation.portraitUp;
  }

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  final GlobalKey<_CameraFocusAreaState> _focusAreaKey = GlobalKey();
  final GlobalKey<_CameraScannerAreaState> _scannerAreaKey = GlobalKey();

  double _currentZoomLevel = 1.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    locator<CameraBloc>().add(Init_CameraEvent(type: widget.settings.type));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (widget.settings.type == CameraType.camera) {
        locator<CameraBloc>().add(InitCamera_CameraEvent());
      }

      locator<CameraBloc>().add(UpdatePermissionStatus_CameraEvent());
    }

    if (state == AppLifecycleState.inactive) {
      locator<CameraBloc>().state.controller?.pausePreview();
    }
  }

  @override
  void deactivate() {
    SystemChrome.setPreferredOrientations(locator<DeviceService>().orientations(context));
    super.deactivate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    locator<CameraBloc>().state.controller?.dispose();
    locator<CameraBloc>().add(Reset_CameraEvent());
    super.dispose();
  }

  Future<void> _onControllerCreated(CameraController? controller, Exception? exception) async {
    if (controller == null) return;
    locator<CameraBloc>().add(InitScanner_CameraEvent(controller: controller));
  }

  Future<void> _handlePermissionStatus() async {
    if (!await locator<PermissionService>().isCameraGranted) {
      final isPermissionGranted = await locator<PermissionService>().requestCameraPermission(context: context);
      locator<CameraBloc>().add(UpdatePermissionStatus_CameraEvent(isPermissionGranted: isPermissionGranted));
      await Future.delayed(OtherConstants.defaultAnimationDuration);
    }
  }

  Future<void> _onScanHandler(Code code) async {
    locator<CameraBloc>().add(TakeScan_CameraEvent(
      code: code,
      type: widget.settings.type,
      allowedFormats: widget.settings.allowedFormats,
      onResponse: BlocEventResponse(
        onResult: (result) {
          _scannerAreaKey.currentState?.startAnimation();
          if (widget.settings.onScanned != null) {
            widget.settings.onScanned!(CameraResultEntity(
              codes: {code},
            ));
          }

          if (widget.settings.type == CameraType.scannerOne) {
            AppRouter.configs.pop(CameraResultEntity(
              codes: locator<CameraBloc>().state.scannedCodes,
            ));
          }
        },
      ),
    ));
  }

  void _onTakePictureHandler(CameraState state) {
    locator<CameraBloc>().add(TakePhoto_CameraEvent());
  }

  void _onDeletePhotoHandler() {
    locator<CameraBloc>().add(ClearPhotoAndScans_CameraEvent());
  }

  void _onSendPhotoAndScansHandler() {
    AppRouter.configs.pop(CameraResultEntity(
      image: widget.settings.type == CameraType.camera ? locator<CameraBloc>().state.imageFile : null,
      codes: widget.settings.type != CameraType.camera ? locator<CameraBloc>().state.scannedCodes : null,
    ));
  }

  void _onSwitchCameraHandler() {
    locator<CameraBloc>().add(SwitchCamera_CameraEvent(
      type: widget.settings.type,
    ));
  }

  void _onToggleFlashHandler() {
    locator<CameraBloc>().add(ToggleFlashMode_CameraEvent(
      type: widget.settings.type,
    ));
  }

  // void _onToggleOrientationHandler(bool isOrientationLocked) {
  //   locator<CameraBloc>().add(ToggleOrientationMode_CameraEvent());
  //   if (isOrientationLocked) {
  //     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //   } else {
  //     SystemChrome.setPreferredOrientations(locator<DeviceService>().orientations(context));
  //   }
  // }

  void _onFocusHandler(TapDownDetails details, BoxConstraints constraints) {
    locator<CameraBloc>().add(UpdateFocusPosition_CameraEvent(
      details: details,
      constraints: constraints,
      onResponse: BlocEventResponse(
        onResult: (result) {
          _focusAreaKey.currentState?.startAnimation();
        },
      ),
    ));
  }

  Future<void> _onHandleScaleUpdate(CameraState state, ScaleUpdateDetails details) async {
    if (!state.isCameraReady) return;
    double zoom = _currentZoomLevel * details.scale.clamp(0.75, 1.25);
    zoom = zoom.clamp(state.minZoomLevel, state.maxZoomLevel);
    setState(() {
      _currentZoomLevel = zoom;
    });

    await state.controller!.setZoomLevel(zoom);
  }

  double _calculateOverlayBorderSize() {
    final preferredSize = MediaQuery.sizeOf(context).longestSide * 0.12;
    return preferredSize.clamp(80.0, 120.0);
  }

  Widget _buildOverlayTopBorder(CameraState state, Orientation orientation) {
    return Container(
      height: orientation == Orientation.portrait ? _calculateOverlayBorderSize() : null,
      width: orientation == Orientation.portrait ? null : _calculateOverlayBorderSize(),
      padding: orientation == Orientation.portrait
          ? EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0)
          : EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
      color: ColorConstants.cameraOverlayBG(),
      child: _CameraSupportButtons(
        type: widget.settings.type,
        orientation: orientation,
        flashMode: state.selectedFlashMode,
        isOrientationLocked: state.isOrientationLocked,
        onToggleFlash: _onToggleFlashHandler,
        onLockOrientation: null,
        // onLockOrientation: () => _onToggleOrientationHandler(!state.isOrientationLocked),
        onSwitchCamera: widget.settings.type == CameraType.camera ? _onSwitchCameraHandler : null,
      ),
    );
  }

  Widget _buildOverlayBottomBorder(CameraState state, Orientation orientation) {
    return Container(
      height: orientation == Orientation.portrait ? _calculateOverlayBorderSize() : null,
      width: orientation == Orientation.portrait ? null : _calculateOverlayBorderSize(),
      padding: orientation == Orientation.portrait
          ? EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0)
          : EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
      color: ColorConstants.cameraOverlayBG(),
      child: Transform.translate(
        offset: orientation == Orientation.portrait ? Offset.zero : Offset(0.0, -MediaQuery.viewPaddingOf(context).top * 0.5),
        child: Flex(
          direction: orientation == Orientation.portrait ? Axis.horizontal : Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.settings.type == CameraType.camera)
              _CameraActionButton(
                size: _calculateOverlayBorderSize() * 0.8,
                onTap: () => _onTakePictureHandler(state),
              ),
            if (widget.settings.type == CameraType.scannerMany && state.scannedCodes.isNotEmpty)
              CustomIconButton(
                content: SvgPicture.asset(
                  ImageConstants.icSuccess,
                  height: 30.0,
                  width: 30.0,
                  fit: BoxFit.fill,
                ),
                onTap: _onSendPhotoAndScansHandler,
                options: CustomButtonOptions(
                  size: 48.0,
                  padding: EdgeInsets.zero,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPreview(CameraState state, Orientation orientation) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (state.isCameraReady) ...[
          Positioned.fill(
            child: AspectRatio(
              aspectRatio: state.controller!.value.previewSize!.width / state.controller!.value.previewSize!.height,
              child: LayoutBuilder(
                builder: (_, constraints) {
                  return GestureDetector(
                    onDoubleTapDown: (details) => _onFocusHandler(details, constraints),
                    onScaleUpdate: (details) => _onHandleScaleUpdate(state, details),
                    child: CameraPreview(state.controller!),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            bottom: orientation == Orientation.portrait ? null : 0.0,
            left: orientation == Orientation.portrait ? 0.0 : CameraScreen.predictDeviceOrientation(context, orientation) == DeviceOrientation.landscapeLeft ? 0.0 : null,
            right: orientation == Orientation.portrait ? 0.0 : CameraScreen.predictDeviceOrientation(context, orientation) == DeviceOrientation.landscapeRight ? 0.0 : null,
            child: _buildOverlayTopBorder(state, orientation),
          ),
          Positioned(
            top: orientation == Orientation.portrait ? null : 0.0,
            bottom: 0.0,
            left: orientation == Orientation.portrait ? 0.0 : CameraScreen.predictDeviceOrientation(context, orientation) == DeviceOrientation.landscapeLeft ? null : 0.0,
            right: orientation == Orientation.portrait ? 0.0 : CameraScreen.predictDeviceOrientation(context, orientation) == DeviceOrientation.landscapeRight ? null : 0.0,
            child: _buildOverlayBottomBorder(state, orientation),
          ),
          Positioned(
            top: state.currentFocusPositionY - 40.0,
            left: state.currentFocusPositionX - 40.0,
            child: _CameraFocusArea(key: _focusAreaKey),
          ),
        ],
        if (state.imageFile != null) ...[
          Positioned.fill(
            child: _PhotoPreview(
              image: state.imageFile!,
              orientation: orientation,
              offset: orientation == Orientation.portrait ? Offset.zero : Offset(0.0, -MediaQuery.viewPaddingOf(context).top * 0.5),
              borderSize: _calculateOverlayBorderSize(),
              onCancel: _onDeletePhotoHandler,
              onSubmit: _onSendPhotoAndScansHandler,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildScannerPreview(CameraState state, Orientation orientation) {
    return Stack(
      fit: StackFit.expand,
      children: [
        LayoutBuilder(
          builder: (_, constraints) {
            return GestureDetector(
              onDoubleTapDown: (details) => _onFocusHandler(details, constraints),
              onScaleUpdate: (details) => _onHandleScaleUpdate(state, details),
              child: ReaderWidget(
                onControllerCreated: _onControllerCreated,
                onScan: _onScanHandler,
                scanDelay: Duration(milliseconds: 200),
                scanDelaySuccess: Duration(milliseconds: 1500),
                tryHarder: true,
                tryInverted: true,
                showScannerOverlay: false,
                showGallery: false,
                showFlashlight: false,
                showToggleCamera: false,
              ),
            );
          },
        ),
        if (state.isCameraReady) ...[
          Positioned(
            top: 0.0,
            bottom: orientation == Orientation.portrait ? null : 0.0,
            left: orientation == Orientation.portrait ? 0.0 : CameraScreen.predictDeviceOrientation(context, orientation) == DeviceOrientation.landscapeLeft ? 0.0 : null,
            right: orientation == Orientation.portrait ? 0.0 : CameraScreen.predictDeviceOrientation(context, orientation) == DeviceOrientation.landscapeRight ? 0.0 : null,
            child: _buildOverlayTopBorder(state, orientation),
          ),
          Positioned(
            top: orientation == Orientation.portrait ? null : 0.0,
            bottom: 0.0,
            left: orientation == Orientation.portrait ? 0.0 : CameraScreen.predictDeviceOrientation(context, orientation) == DeviceOrientation.landscapeLeft ? null : 0.0,
            right: orientation == Orientation.portrait ? 0.0 : CameraScreen.predictDeviceOrientation(context, orientation) == DeviceOrientation.landscapeRight ? null : 0.0,
            child: _buildOverlayBottomBorder(state, orientation),
          ),
          Center(
            child: IgnorePointer(
              child: _CameraScannerArea(key: _scannerAreaKey),
            ),
          ),
          Positioned(
            top: state.currentFocusPositionY - 40.0,
            left: state.currentFocusPositionX - 40.0,
            child: _CameraFocusArea(key: _focusAreaKey),
          ),
        ],
      ],
    );
  }

  Widget _buildPermissionErrorPreview() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: Container(
            color: ColorConstants.cameraOverlayBG(),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: 'camera.settings.label'.tr(),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: ColorConstants.textWhite(),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                ),
                SizedBox(height: 12.0),
                CustomText(
                  text: 'camera.settings.description'.tr(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ColorConstants.textWhite().withValues(alpha: 0.5),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                ),
                SizedBox(height: 20.0),
                CustomTextButton(
                  content: 'camera.settings.button'.tr(),
                  onTap: _handlePermissionStatus,
                  isExpanded: false,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingPreview() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: Container(
            color: ColorConstants.cameraOverlayBG(),
          ),
        ),
        Center(
          child: CustomProgressIndicator(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      options: ScaffoldWrapperOptions(
        safeArea: [SafeAreaType.top],
        withKeyboardResize: false,
        backgroundColor: ColorConstants.cameraBG(),
      ),
      child: BlocBuilder<CameraBloc, CameraState>(
        builder: (_, state) {
          if (!state.isReady) {
            return _buildLoadingPreview();
          }

          if (!state.isPermissionGranted) {
            return _buildPermissionErrorPreview();
          }

          return OrientationBuilder(
            builder: (_, orientation) {
              return widget.settings.type == CameraType.camera
                  ? _buildCameraPreview(state, orientation)
                  : _buildScannerPreview(state, orientation);
            }
          );
        },
      ),
    );
  }
}

class _CameraActionButton extends StatefulWidget {
  final double size;
  final VoidCallback onTap;

  const _CameraActionButton({
    required this.size,
    required this.onTap,
  }) : assert(size >= 0.0);

  @override
  State<_CameraActionButton> createState() => _CameraActionButtonState();
}

class _CameraActionButtonState extends State<_CameraActionButton> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.9), weight: 50.0),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 50.0),
    ]).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapHandler() {
    _animationController.forward(from: 0.0);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: _onTapHandler,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: widget.size,
                  width: widget.size,
                  decoration: BoxDecoration(
                    color: ColorConstants.cameraButtonWhite(),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  height: widget.size - 8.0,
                  width: widget.size - 8.0,
                  decoration: BoxDecoration(
                    color: ColorConstants.cameraButtonBlack(),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  height: widget.size - 16.0,
                  width: widget.size - 16.0,
                  decoration: BoxDecoration(
                    color: ColorConstants.cameraButtonWhite(),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CameraSupportButtons extends StatelessWidget {
  final CameraType type;
  final Orientation orientation;
  final FlashMode flashMode;
  final bool isOrientationLocked;
  final VoidCallback onToggleFlash;
  final VoidCallback? onLockOrientation;
  final VoidCallback? onSwitchCamera;

  const _CameraSupportButtons({
    required this.type,
    required this.orientation,
    required this.flashMode,
    required this.isOrientationLocked,
    required this.onToggleFlash,
    required this.onLockOrientation,
    required this.onSwitchCamera,
  });

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: orientation == Orientation.portrait ? Axis.horizontal : Axis.vertical,
      children: [
        CustomIconButton(
          content: Icon(
            switch (flashMode) {
              FlashMode.off => type == CameraType.camera ? Icons.flash_off : Icons.flashlight_off,
              FlashMode.auto => type == CameraType.camera ? Icons.flash_auto : Icons.flashlight_on,
              FlashMode.always => type == CameraType.camera ? Icons.flash_auto : Icons.flashlight_on,
              FlashMode.torch => Icons.flashlight_on,
            },
            size: 30.0,
            color: ColorConstants.cameraButtonWhite(),
          ),
          onTap: onToggleFlash,
          options: CustomButtonOptions(
            size: 48.0,
            padding: EdgeInsets.zero,
            splashColor: ColorConstants.cameraButtonWhite().withValues(alpha: 0.2),
          ),
        ),
        Spacer(),
        SizedBox(width: 20.0),
        if (onLockOrientation != null) ...[
          CustomIconButton(
            content: Transform.rotate(
              angle: isOrientationLocked ? 0.0 : math.pi / 4.0,
              child: Icon(
                isOrientationLocked ? Icons.sync_disabled : Icons.sync,
                size: 30.0,
                color: ColorConstants.cameraButtonWhite(),
              ),
            ),
            onTap: onLockOrientation!,
            options: CustomButtonOptions(
              size: 48.0,
              padding: EdgeInsets.zero,
              splashColor: ColorConstants.cameraButtonWhite().withValues(alpha: 0.2),
            ),
          ),
        ],
        if (onSwitchCamera != null) ...[
          SizedBox(width: 8.0),
          CustomIconButton(
            content: Icon(
              Icons.cameraswitch,
              size: 30.0,
              color: ColorConstants.cameraButtonWhite(),
            ),
            onTap: onSwitchCamera!,
            options: CustomButtonOptions(
              size: 48.0,
              padding: EdgeInsets.zero,
              splashColor: ColorConstants.cameraButtonWhite().withValues(alpha: 0.2),
            ),
          ),
        ],
      ],
    );
  }
}

class _CameraFocusArea extends StatefulWidget {
  const _CameraFocusArea({super.key});

  @override
  State<_CameraFocusArea> createState() => _CameraFocusAreaState();
}

class _CameraFocusAreaState extends State<_CameraFocusArea> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 20.0),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 80.0),
    ]).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeIn));

    _opacityAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 20.0),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.5), weight: 10.0),
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 1.0), weight: 10.0),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.5), weight: 10.0),
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 1.0), weight: 10.0),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 20.0),
    ]).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void startAnimation() {
    _animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            height: 80.0,
            width: 80.0,
            decoration: BoxDecoration(
              border: Border.all(
                color: ColorConstants.cameraFocusArea().withValues(alpha: _opacityAnimation.value),
                width: 2.0,
              ),
            ),
          ),
        );
      }
    );
  }
}

class _CameraScannerArea extends StatefulWidget {
  const _CameraScannerArea({super.key});

  @override
  State<_CameraScannerArea> createState() => _CameraScannerAreaState();
}

class _CameraScannerAreaState extends State<_CameraScannerArea> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _colorAnimation = TweenSequence<Color?>([
      TweenSequenceItem(
        tween: ColorTween(begin: ColorConstants.cameraScannerArea(), end: ColorConstants.cameraScannerSuccess()),
        weight: 20.0,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: ColorConstants.cameraScannerSuccess(), end: ColorConstants.cameraScannerSuccess()),
        weight: 60.0,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: ColorConstants.cameraScannerSuccess(), end: ColorConstants.cameraScannerArea()),
        weight: 20.0,
      ),
    ]).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void startAnimation() {
    _animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, child) {
        return Container(
          height: 200.0,
          width: 200.0,
          decoration: BoxDecoration(
            border: Border.all(color: _colorAnimation.value ?? ColorConstants.cameraScannerArea(), width: 3.0),
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
        );
      },
    );
  }
}


class _PhotoPreview extends StatelessWidget {
  final XFile image;
  final Orientation orientation;
  final Offset offset;
  final double borderSize;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  const _PhotoPreview({
    required this.image,
    required this.orientation,
    required this.offset,
    required this.borderSize,
    required this.onCancel,
    required this.onSubmit,
  });

  Widget _buildOverlayTopBorder() {
    return Container(
      height: orientation == Orientation.portrait ? borderSize : null,
      width: orientation == Orientation.portrait ? null : borderSize,
      color: ColorConstants.cameraBG(),
    );
  }

  Widget _buildOverlayBottomBorder(BuildContext context) {
    return Container(
      height: orientation == Orientation.portrait ? borderSize : null,
      width: orientation == Orientation.portrait ? null : borderSize,
      color: ColorConstants.cameraBG(),
      child: Transform.translate(
        offset: offset,
        child: Flex(
          direction: orientation == Orientation.portrait ? Axis.horizontal : Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomIconButton(
              content: SvgPicture.asset(
                ImageConstants.icWarning,
                height: borderSize * 0.5,
                width: borderSize * 0.5,
                fit: BoxFit.fill,
              ),
              onTap: onCancel,
              options: CustomButtonOptions(
                size: borderSize * 0.5,
                padding: EdgeInsets.zero,
              ),
            ),
            CustomIconButton(
              content: SvgPicture.asset(
                ImageConstants.icSuccess,
                height: borderSize * 0.5,
                width: borderSize * 0.5,
                fit: BoxFit.fill,
              ),
              onTap: onSubmit,
              options: CustomButtonOptions(
                size: borderSize * 0.5,
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: ColorConstants.cameraBG(),
          ),
        ),
        Positioned.fill(
          child: AspectRatio(
            aspectRatio: locator<CameraBloc>().state.controller!.value.previewSize!.width / locator<CameraBloc>().state.controller!.value.previewSize!.height,
            child: InteractiveViewer(
              maxScale: 5.0,
              minScale: 1.0,
              child: Image.file(
                File(image.path),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0.0,
          bottom: orientation == Orientation.portrait ? null : 0.0,
          left: orientation == Orientation.portrait ? 0.0 : CameraScreen.predictDeviceOrientation(context, orientation) == DeviceOrientation.landscapeLeft ? null : 0.0,
          right: orientation == Orientation.portrait ? 0.0 : CameraScreen.predictDeviceOrientation(context, orientation) == DeviceOrientation.landscapeRight ? null : 0.0,
          child: _buildOverlayTopBorder(),
        ),
        Positioned(
          top: orientation == Orientation.portrait ? null : 0.0,
          bottom: 0.0,
          left: orientation == Orientation.portrait ? 0.0 : CameraScreen.predictDeviceOrientation(context, orientation) == DeviceOrientation.landscapeLeft ? 0.0 : null,
          right: orientation == Orientation.portrait ? 0.0 : CameraScreen.predictDeviceOrientation(context, orientation) == DeviceOrientation.landscapeRight ? 0.0 : null,
          child: _buildOverlayBottomBorder(context),
        ),
      ],
    );
  }
}