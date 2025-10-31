part of '../../camera.dart';

class CameraState extends BlocState {
  final List<CameraDescription> cameras;
  final CameraController? controller;

  final XFile? imageFile;
  final Set<Code> scannedCodes;

  final int selectedCameraIndex;
  final FlashMode selectedFlashMode;
  final bool isOrientationLocked;
  final double currentFocusPositionX;
  final double currentFocusPositionY;

  final double maxZoomLevel;
  final double minZoomLevel;

  final bool isPermissionGranted;

  const CameraState({
    required this.cameras,
    required this.controller,
    required this.imageFile,
    required this.scannedCodes,
    required this.selectedCameraIndex,
    required this.selectedFlashMode,
    required this.isOrientationLocked,
    required this.currentFocusPositionX,
    required this.currentFocusPositionY,
    required this.maxZoomLevel,
    required this.minZoomLevel,
    required this.isPermissionGranted,
    super.isLocked = false,
    super.isReady = false,
  });

  bool get isCameraReady => controller != null && controller?.value.isInitialized == true;

  factory CameraState.initial() {
    return const CameraState(
      cameras: [],
      controller: null,
      imageFile: null,
      scannedCodes: {},
      selectedCameraIndex: 0,
      selectedFlashMode: FlashMode.off,
      isOrientationLocked: false,
      currentFocusPositionX: 0.0,
      currentFocusPositionY: 0.0,
      maxZoomLevel: 1.0,
      minZoomLevel: 1.0,
      isPermissionGranted: false,
    );
  }

  @override
  CameraState copyWith({
    List<CameraDescription>? cameras,
    int? selectedCameraIndex,
    FlashMode? selectedFlashMode,
    bool? isOrientationLocked,
    double? currentFocusPositionX,
    double? currentFocusPositionY,
    double? maxZoomLevel,
    double? minZoomLevel,
    bool? isPermissionGranted,
    bool? isLocked,
    bool? isReady,
  }) {
    return CameraState(
      cameras: cameras ?? this.cameras,
      controller: controller,
      imageFile: imageFile,
      scannedCodes: scannedCodes,
      selectedCameraIndex: selectedCameraIndex ?? this.selectedCameraIndex,
      selectedFlashMode: selectedFlashMode ?? this.selectedFlashMode,
      isOrientationLocked: isOrientationLocked ?? this.isOrientationLocked,
      currentFocusPositionX: currentFocusPositionX ?? this.currentFocusPositionX,
      currentFocusPositionY: currentFocusPositionY ?? this.currentFocusPositionY,
      maxZoomLevel: maxZoomLevel ?? this.maxZoomLevel,
      minZoomLevel: minZoomLevel ?? this.minZoomLevel,
      isPermissionGranted: isPermissionGranted ?? this.isPermissionGranted,
      isLocked: isLocked ?? this.isLocked,
      isReady: isReady ?? this.isReady,
    );
  }

  @override
  CameraState copyWithForced({CameraController? controller}) {
    return CameraState(
      cameras: cameras,
      controller: controller,
      imageFile: imageFile,
      scannedCodes: scannedCodes,
      selectedCameraIndex: selectedCameraIndex,
      selectedFlashMode: selectedFlashMode,
      isOrientationLocked: isOrientationLocked,
      currentFocusPositionX: currentFocusPositionX,
      currentFocusPositionY: currentFocusPositionY,
      maxZoomLevel: maxZoomLevel,
      minZoomLevel: minZoomLevel,
      isPermissionGranted: isPermissionGranted,
      isLocked: isLocked,
      isReady: isReady,
    );
  }

  CameraState updatePhoto({XFile? imageFile}) {
    return CameraState(
      cameras: cameras,
      controller: controller,
      imageFile: imageFile,
      scannedCodes: scannedCodes,
      selectedCameraIndex: selectedCameraIndex,
      selectedFlashMode: selectedFlashMode,
      isOrientationLocked: isOrientationLocked,
      currentFocusPositionX: currentFocusPositionX,
      currentFocusPositionY: currentFocusPositionY,
      maxZoomLevel: maxZoomLevel,
      minZoomLevel: minZoomLevel,
      isPermissionGranted: isPermissionGranted,
      isLocked: isLocked,
      isReady: isReady,
    );
  }

  CameraState updateScans({Set<Code>? scannedCodes}) {
    return CameraState(
      cameras: cameras,
      controller: controller,
      imageFile: imageFile,
      scannedCodes: scannedCodes ?? {},
      selectedCameraIndex: selectedCameraIndex,
      selectedFlashMode: selectedFlashMode,
      isOrientationLocked: isOrientationLocked,
      currentFocusPositionX: currentFocusPositionX,
      currentFocusPositionY: currentFocusPositionY,
      maxZoomLevel: maxZoomLevel,
      minZoomLevel: minZoomLevel,
      isPermissionGranted: isPermissionGranted,
      isLocked: isLocked,
      isReady: isReady,
    );
  }
}

