import 'package:shared_preferences/shared_preferences.dart';

import '../../../injection_container.dart';
import '../../services/device_service.dart';

/// Abstract model of shared preferences
/// To separate all other implementations we use personal id and build mode name
class AbstractSharedPreferencesDatasource {
  final String id;
  static late SharedPreferences _preferences;

  const AbstractSharedPreferencesDatasource({required this.id});

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> deletePreferences() async {
    await _preferences.clear();
  }

  dynamic read(String key) {
    return _preferences.get(_getStorageID(key));
  }

  Future<void> write(String key, dynamic value) async {
    switch (value.runtimeType) {
      case const (String): {
        await _preferences.setString(_getStorageID(key), value) ;
        break;
      }

      case const (int): {
        await _preferences.setInt(_getStorageID(key), value) ;
        break;
      }

      case const (double): {
        await _preferences.setDouble(_getStorageID(key), value) ;
        break;
      }

      case const (bool): {
        await _preferences.setBool(_getStorageID(key), value) ;
        break;
      }
    }
  }

  Future<void> delete(String key) async {
    await _preferences.remove(_getStorageID(key));
  }

  String _getStorageID(String key) {
    return '$id.shared_preferences.${locator<DeviceService>().currentBuildMode().toBuildSuffix()}.$key';
  }
}
