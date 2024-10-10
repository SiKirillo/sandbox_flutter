part of '../common.dart';

class DeviceService {
  late final PackageInfo _packageInfo;
  bool _isPhysicalDevice = false;

  static const _testPackageSuffix = '.test';
  static const _devPackageSuffix = '.dev';

  String get packageName => _packageInfo.packageName;
  bool get isPhysicalDevice => _isPhysicalDevice;

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

  BuildMode getBuildModeFromFlavor() {
    if (_packageInfo.packageName.contains(_devPackageSuffix)) {
      return BuildMode.dev;
    }

    if (_packageInfo.packageName.contains(_testPackageSuffix)) {
      return BuildMode.staging;
    }

    return BuildMode.prod;
  }

  BuildMode getBuildModeFromArgs() {
    if (kDebugMode) {
      return BuildMode.dev;
    }

    if (kProfileMode) {
      return BuildMode.staging;
    }

    return BuildMode.prod;
  }

  String getBuildBanner({bool isFlavor = false, bool isFull = false}) {
    return '${isFlavor ? getBuildModeFromFlavor().toStringLabel() : getBuildModeFromArgs().toStringLabel()} ${_packageInfo.version}${isFull ? '.v${_packageInfo.buildNumber}' : ''}';
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