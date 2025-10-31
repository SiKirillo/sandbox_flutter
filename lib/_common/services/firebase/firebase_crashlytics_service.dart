part of 'firebase_core_service.dart';

class FirebaseCrashlyticsService {
  static Future<void> init() async {
    LoggerService.logTrace('FirebaseCrashlyticsService -> init()');
    await Future.wait([
      FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true),
      FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true),
      FirebaseCrashlytics.instance.log('FirebaseCrashlyticsService -> init()'),
      FirebaseCrashlytics.instance.setCustomKey('app_version', locator<DeviceService>().getBuildVersionPlaceholder()),
    ]);

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  static Future<void> recordError({
    required dynamic error,
    required dynamic stackTrace,
    bool isFatal = false,
  }) async {
    await FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: isFatal);
  }

  static void crash() {
    FirebaseCrashlytics.instance.log('FirebaseCrashlyticsService -> crash()');
    FirebaseCrashlytics.instance.crash();
  }
}
