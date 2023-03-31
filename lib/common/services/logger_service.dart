import 'package:flutter/material.dart';

/// This service handle all your prints in console
class LoggerService {
  static void logDebug(String message) {
    final time = DateTime.now();
    final formattedTime = '${time.year}-${time.month}-${time.day} ${time.hour}:${time.minute}:${time.second}';
    debugPrint('***** $formattedTime > $message');
  }
}