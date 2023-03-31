import 'package:package_info_plus/package_info_plus.dart';

/// This service handle app service info
class DeviceService {
  late final PackageInfo _packageInfo;

  static const _devPackageName = 'com.samarlandsoft.sandbox_flutter.dev';
  static const _prodPackageName = 'com.samarlandsoft.sandbox_flutter';

  Future<void> init() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  String get packageName {
    return _packageInfo.packageName;
  }

  BuildMode currentBuildMode() {
    switch (_packageInfo.packageName) {
      case _prodPackageName:
        return BuildMode.prod;

      default:
        return BuildMode.dev;
    }
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