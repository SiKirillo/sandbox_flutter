part of '../../camera.dart';

class CameraResultEntity {
  final XFile? image;
  final Set<Code>? codes;

  const CameraResultEntity({
    this.image,
    this.codes,
  });
}