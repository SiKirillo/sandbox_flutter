import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// This service handle app service info
class DeviceService {
  late final PackageInfo _packageInfo;
  late final bool _isPhysicalDevice;

  static const _devPackageName = 'com.samarlandsoft.sandbox_flutter.dev';
  static const _prodPackageName = 'com.samarlandsoft.sandbox_flutter';

  String get packageName => _packageInfo.packageName;
  bool get isPhysicalDevice => _isPhysicalDevice;

  Future<void> init() async {
    _packageInfo = await PackageInfo.fromPlatform();

    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      _isPhysicalDevice = androidInfo.isPhysicalDevice;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      _isPhysicalDevice = iosInfo.isPhysicalDevice;
    } else {
      _isPhysicalDevice = true;
    }
  }

  BuildMode currentBuildMode() {
    switch (_packageInfo.packageName) {
      case _prodPackageName:
        return BuildMode.prod;

      default:
        return BuildMode.dev;
    }
  }

  String currentBuildBanner() {
    return '${currentBuildMode().toStringLabel()} ${_packageInfo.version}';
  }
}

enum BuildMode {
  dev,
  prod,
}

extension BuildModeExtension on BuildMode {
  String toStringLabel() {
    switch (this) {
      case BuildMode.prod:
        return 'Production';

      default:
        return 'Dev';
    }
  }

  String toBuildSuffix() {
    switch (this) {
      case BuildMode.prod:
        return 'prod';

      default:
        return 'dev';
    }
  }
}