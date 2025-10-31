part of '../../camera.dart';

class CameraSettingsOptions {
  final CameraType type;
  final List<int> allowedFormats;
  final Function(CameraResultEntity)? onScanned;

  const CameraSettingsOptions({
    this.type = CameraType.camera,
    this.allowedFormats = const [Format.any],
    this.onScanned,
  });
}