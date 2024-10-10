part of '../../common.dart';

/// Abstract model of secure storage
/// To separate all other implementations we use personal id and build mode name
class AbstractSecureDatasource {
  final String id;
  static const _storage = FlutterSecureStorage();

  const AbstractSecureDatasource({required this.id});

  static Future<void> deleteStorage() async {
    await _storage.deleteAll();
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: _getStorageID(key));
  }

  Future<void> write(String key, String? value) async {
    await _storage.write(key: _getStorageID(key), value: value);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: _getStorageID(key));
  }
  
  String _getStorageID(String key) {
    return '$id.secure_storage.${locator<DeviceService>().getBuildModeFromFlavor().toBuildSuffix()}.$key';
  }
}
