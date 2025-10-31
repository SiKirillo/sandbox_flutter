part of '../../camera.dart';

class CameraRepository {
  Future<File?> generateFileFromBytes(String bytes) async {
    try {
      final decodedBytes = base64Decode(bytes);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/reconstructed-${bytes.split('').fold(0, (prev, current) => prev + current.codeUnitAt(0))}-${DateTime.now().millisecondsSinceEpoch}.jpg');
      return await file.writeAsBytes(decodedBytes);
    } on Exception catch (e) {
      LoggerService.logError('Exception while converting bytes', exception: e);
    }

    return null;
  }
}