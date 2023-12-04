import 'dart:isolate';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'logger_service.dart';

class FirebaseService {
  late final FirebaseAnalytics _analytics;
  late final FirebaseCrashlytics _crashlytics;

  Future<void> init() async {
    LoggerService.logDebug('FirebaseService -> init()');

    await Firebase.initializeApp();
    _crashlytics = FirebaseCrashlytics.instance;
    _analytics = FirebaseAnalytics.instance;

    await _startCrashlytics();
    await _analytics.setAnalyticsCollectionEnabled(true);
  }

  Future<void> _startCrashlytics() async {
    await _crashlytics.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = _crashlytics.recordFlutterError;

    /// To catch errors that happen outside of the Flutter context
    Isolate.current.addErrorListener(RawReceivePort((pair) async {
      final errorAndStacktrace = pair as List<dynamic>;
      await _crashlytics.recordError(
        errorAndStacktrace.first,
        errorAndStacktrace.last,
      );
    }).sendPort);
  }
}