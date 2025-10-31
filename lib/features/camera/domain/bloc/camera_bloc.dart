part of '../../camera.dart';

class CameraBloc extends Bloc<CameraBlocEvent, CameraState> {
  CameraBloc() : super(CameraState.initial()) {
    /// Common
    on<Init_CameraEvent>(_onInit);
    on<InitCamera_CameraEvent>(_onInitCamera);
    on<InitScanner_CameraEvent>(_onInitScanner);
    on<SwitchCamera_CameraEvent>(_onSwitchCamera);
    on<ToggleFlashMode_CameraEvent>(_onToggleFlashMode);
    on<ToggleOrientationMode_CameraEvent>(_onToggleOrientationMode);
    on<UpdateFocusPosition_CameraEvent>(_onUpdateFocusPosition);
    on<UpdateMinAndMaxZoomLevel_CameraEvent>(_onUpdateMinAndMaxZoomLevel);
    on<UpdatePermissionStatus_CameraEvent>(_onUpdatePermissionStatus);
    on<TakePhoto_CameraEvent>(_onTakePhoto);
    on<TakeScan_CameraEvent>(_onTakeScan);
    on<ClearPhotoAndScans_CameraEvent>(_onClearPhotoAndScans);
    /// Service
    on<Reset_CameraEvent>(_onReset);
    on<HandleFailure_CameraEvent>(_onHandleFailure);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    locator<InAppOverlayProvider>().hide();
    add(HandleFailure_CameraEvent());
  }

  /// Common
  Future<void> _onInit(Init_CameraEvent event, Emitter<CameraState> emit) async {
    final cameras = await availableCameras();
    final isPermissionGranted = await locator<PermissionService>().isCameraGranted;

    emit(state.copyWith(
      cameras: cameras,
      isPermissionGranted: isPermissionGranted,
      isReady: true,
    ));

    if (event.type == CameraType.camera) {
      locator<CameraBloc>().add(InitCamera_CameraEvent());
    }
  }

  Future<void> _onInitCamera(InitCamera_CameraEvent event, Emitter<CameraState> emit) async {
    if (state.cameras.isEmpty) return;
    final controller = CameraController(
      state.cameras[state.selectedCameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await controller.initialize();
    final maxZoomLevel = await controller.getMaxZoomLevel();
    final minZoomLevel = await controller.getMinZoomLevel();

    await Future.wait([
      controller.setFocusMode(FocusMode.auto),
      controller.setFlashMode(state.selectedFlashMode),
    ]);

    emit(state.copyWithForced(controller: controller));
    emit(state.copyWith(
      maxZoomLevel: maxZoomLevel,
      minZoomLevel: minZoomLevel,
    ));
  }

  Future<void> _onInitScanner(InitScanner_CameraEvent event, Emitter<CameraState> emit) async {
    final maxZoomLevel = await event.controller.getMaxZoomLevel();
    final minZoomLevel = await event.controller.getMinZoomLevel();

    await Future.wait([
      event.controller.setFocusMode(FocusMode.auto),
      event.controller.setFlashMode(state.selectedFlashMode),
    ]);

    emit(state.copyWithForced(controller: event.controller));
    emit(state.copyWith(
      maxZoomLevel: maxZoomLevel,
      minZoomLevel: minZoomLevel,
    ));
  }

  void _onSwitchCamera(SwitchCamera_CameraEvent event, Emitter<CameraState> emit) {
    final nextCameraIndex = (state.selectedCameraIndex + 1) % state.cameras.length;
    emit(state.copyWith(selectedCameraIndex: nextCameraIndex));

    if (event.type == CameraType.camera) {
      add(InitCamera_CameraEvent());
    }
  }

  void _onToggleFlashMode(ToggleFlashMode_CameraEvent event, Emitter<CameraState> emit) {
    if (!state.isCameraReady) return;
    FlashMode nextMode;

    switch (state.selectedFlashMode) {
      case FlashMode.off:
        nextMode = event.type == CameraType.camera ? FlashMode.always : FlashMode.torch;
        break;

      case FlashMode.auto:
        nextMode = FlashMode.off;
        break;

      case FlashMode.always:
        nextMode = FlashMode.off;
        break;

      case FlashMode.torch:
        nextMode = FlashMode.off;
        break;
    }

    state.controller?.setFlashMode(nextMode);
    emit(state.copyWith(selectedFlashMode: nextMode));
  }

  void _onToggleOrientationMode(ToggleOrientationMode_CameraEvent event, Emitter<CameraState> emit) {
    emit(state.copyWith(isOrientationLocked: !state.isOrientationLocked));
  }

  Future<void> _onUpdateFocusPosition(UpdateFocusPosition_CameraEvent event, Emitter<CameraState> emit) async {
    if (!state.isCameraReady) return;
    final offset = event.details.localPosition;

    /// Convert the tapped point to a normalized point (0.0 - 1.0)
    final dx = offset.dx / event.constraints.maxWidth;
    final dy = offset.dy / event.constraints.maxHeight;

    state.controller?.setFocusPoint(Offset(dx, dy));
    emit(state.copyWith(
      currentFocusPositionX: event.details.globalPosition.dx,
      currentFocusPositionY: event.details.globalPosition.dy,
    ));

    if (event.onResponse?.onResult != null) {
      event.onResponse!.onResult!(null);
    }
  }

  void _onUpdateMinAndMaxZoomLevel(UpdateMinAndMaxZoomLevel_CameraEvent event, Emitter<CameraState> emit) {
    emit(CameraState.initial());
  }

  Future<void> _onUpdatePermissionStatus(UpdatePermissionStatus_CameraEvent event, Emitter<CameraState> emit) async {
    final isPermissionGranted = event.isPermissionGranted ?? await locator<PermissionService>().isCameraGranted;
    emit(state.copyWith(isPermissionGranted: isPermissionGranted));
  }

  Future<void> _onTakePhoto(TakePhoto_CameraEvent event, Emitter<CameraState> emit) async {
    if (!state.isCameraReady) return;
    try {
      final file = await state.controller!.takePicture();
      emit(state.updatePhoto(imageFile: file));
    } on Exception catch (e) {
      LoggerService.logError('Error while taking photo: $e');
    }
  }

  void _onTakeScan(TakeScan_CameraEvent event, Emitter<CameraState> emit) {
    if (event.type == CameraType.scannerOne && state.scannedCodes.isNotEmpty) return;
    final allowedFormat = event.allowedFormats.firstWhereOrNull((t) => (t & (event.code.format ?? 0)) != 0);
    if (event.code.isValid && allowedFormat != null) {
      emit(state.updateScans(scannedCodes: {...state.scannedCodes, event.code}));
      if (event.onResponse?.onResult != null) {
        event.onResponse!.onResult!(null);
      }
    }
  }

  void _onClearPhotoAndScans(ClearPhotoAndScans_CameraEvent event, Emitter<CameraState> emit) {
    emit(state.updatePhoto(imageFile: null));
    emit(state.updateScans(scannedCodes: null));
  }

  /// Service
  void _onReset(Reset_CameraEvent event, Emitter<CameraState> emit) {
    emit(CameraState.initial());
  }

  void _onHandleFailure(HandleFailure_CameraEvent event, Emitter<CameraState> emit) {
    emit(state.copyWith(isLocked: false));
  }
}