part of '../../camera.dart';

abstract class CameraBlocEvent {}

/// Common
class Init_CameraEvent extends CameraBlocEvent {
  final CameraType type;

  Init_CameraEvent({
    required this.type,
  });
}

class InitCamera_CameraEvent extends CameraBlocEvent {}

class InitScanner_CameraEvent extends CameraBlocEvent {
  final CameraController controller;

  InitScanner_CameraEvent({
    required this.controller,
  });
}

class SwitchCamera_CameraEvent extends CameraBlocEvent {
  final CameraType type;

  SwitchCamera_CameraEvent({
    required this.type,
  });
}

class ToggleFlashMode_CameraEvent extends CameraBlocEvent {
  final CameraType type;

  ToggleFlashMode_CameraEvent({
    required this.type,
  });
}

class ToggleOrientationMode_CameraEvent extends CameraBlocEvent {}

class UpdateFocusPosition_CameraEvent extends CameraBlocEvent {
  final TapDownDetails details;
  final BoxConstraints constraints;
  final BlocEventResponse<Failure, void>? onResponse;

  UpdateFocusPosition_CameraEvent({
    required this.details,
    required this.constraints,
    this.onResponse,
  });
}

class UpdateMinAndMaxZoomLevel_CameraEvent extends CameraBlocEvent {
  final double maxZoomLevel;
  final double minZoomLevel;

  UpdateMinAndMaxZoomLevel_CameraEvent({
    required this.maxZoomLevel,
    required this.minZoomLevel,
  });
}

class UpdatePermissionStatus_CameraEvent extends CameraBlocEvent {
  final bool? isPermissionGranted;

  UpdatePermissionStatus_CameraEvent({
    this.isPermissionGranted,
  });
}

class TakePhoto_CameraEvent extends CameraBlocEvent {}

class TakeScan_CameraEvent extends CameraBlocEvent {
  final Code code;
  final CameraType type;
  final List<int> allowedFormats;
  final BlocEventResponse<Failure, void>? onResponse;

  TakeScan_CameraEvent({
    required this.code,
    required this.type,
    required this.allowedFormats,
    this.onResponse,
  });
}

class ClearPhotoAndScans_CameraEvent extends CameraBlocEvent {}

/// Service
class Reset_CameraEvent extends CameraBlocEvent {}

class HandleFailure_CameraEvent extends CameraBlocEvent {}