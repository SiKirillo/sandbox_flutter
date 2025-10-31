import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

import '../../common.dart';
import '../logger/logger_service.dart';

part 'firebase_crashlytics_service.dart';
part 'firebase_remote_config_service.dart';
part 'firebase_messaging_service.dart';

class FirebaseCoreService {
  static Future<FirebaseApp> init({required String name, required FirebaseOptions options}) async {
    LoggerService.logInfo('FirebaseCoreService -> init(name: $name)');
    return await Firebase.initializeApp(name: name, options: options);
  }
}