import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// This service handle app service info
class DeviceService {
  late final PackageInfo _packageInfo;
  late final bool _isPhysicalDevice;

  static const _testPackageSuffix = '.test';
  static const _devPackageSuffix = '.dev';

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
    if (_packageInfo.packageName.contains(_devPackageSuffix)) {
      return BuildMode.dev;
    }

    if (_packageInfo.packageName.contains(_testPackageSuffix)) {
      return BuildMode.staging;
    }

    return BuildMode.prod;
  }

  String currentBuildBanner() {
    return '${currentBuildMode().toStringLabel()} ${_packageInfo.version}';
  }
}

enum BuildMode {
  dev,
  staging,
  prod,
}

extension BuildModeExtension on BuildMode {
  String toStringLabel() {
    switch (this) {
      case BuildMode.prod:
        return 'Production';

      case BuildMode.staging:
        return 'Test';

      default:
        return 'Dev';
    }
  }

  String toBuildSuffix() {
    switch (this) {
      case BuildMode.prod:
        return 'prod';

      case BuildMode.staging:
        return 'test';

      default:
        return 'dev';
    }
  }
}