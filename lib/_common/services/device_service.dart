part of '../common.dart';

class DeviceService {
  late final PackageInfo _packageInfo;
  bool _isPhysicalDevice = false;

  static const _devPackageSuffix = '.dev';
  static const _stablePackageSuffix = '.stable';
  static const _stagingPackageSuffix = '.staging';

  String get packageName => _packageInfo.packageName;
  bool get isPhysicalDevice => _isPhysicalDevice;

  bool get showExperimentalFeatures {
    final flavor = getFlavorMode();
    return flavor == FlavorMode.dev || flavor == FlavorMode.stable;
  }

  Future<void> init() async {
    _packageInfo = await PackageInfo.fromPlatform();

    final deviceInfo = DeviceInfoPlugin();
    if (kIsWeb) {
      return;
    }

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      _isPhysicalDevice = androidInfo.isPhysicalDevice;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      _isPhysicalDevice = iosInfo.isPhysicalDevice;
    }
  }

  FlavorMode getFlavorMode() {
    if (_packageInfo.packageName.contains(_devPackageSuffix)) {
      return FlavorMode.dev;
    }

    if (_packageInfo.packageName.contains(_stablePackageSuffix)) {
      return FlavorMode.stable;
    }

    if (_packageInfo.packageName.contains(_stagingPackageSuffix)) {
      return FlavorMode.staging;
    }

    return FlavorMode.prod;
  }

  BuildMode getBuildMode() {
    if (kDebugMode) {
      return BuildMode.debug;
    }

    if (kProfileMode) {
      return BuildMode.profile;
    }

    return BuildMode.release;
  }

  String getBuildPlaceholderLabel({bool isFlavor = true}) {
    return '${isFlavor ? getFlavorMode().toStringLabel() : getBuildMode().toStringLabel()} ${_packageInfo.version}';
  }

  String getBuildVersionPlaceholder() {
    return _packageInfo.version;
  }

  List<DeviceOrientation> orientations(BuildContext context) {
    if (SizeConstants.isTablet(context: context)) {
      return [
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ];
    } else {
      return [
        DeviceOrientation.portraitUp,
      ];
    }
  }
}

enum FlavorMode {
  dev,
  stable,
  staging,
  prod,
  none;

  String toStringLabel() {
    switch (this) {
      case FlavorMode.dev:
        return 'Dev';

      case FlavorMode.stable:
        return 'Stable';

      case FlavorMode.staging:
        return 'Staging';

      case FlavorMode.prod:
        return 'Production';

      default:
        return 'None';
    }
  }

  String toStringSuffix() {
    switch (this) {
      case FlavorMode.dev:
        return 'dev';

      case FlavorMode.stable:
        return 'stable';

      case FlavorMode.staging:
        return 'staging';

      case FlavorMode.prod:
        return 'production';

      default:
        return 'none';
    }
  }
}

enum BuildMode {
  debug,
  profile,
  release;

  String toStringLabel() {
    switch (this) {
      case BuildMode.debug:
        return 'Debug';

      case BuildMode.profile:
        return 'Profile';

      case BuildMode.release:
        return 'Release';
    }
  }
}