part of '../common.dart';

class LoggerService {
  static final _loggerFailure = Logger(
    printer: PrettyPrinter(methodCount: 10, dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart),
    filter: CustomFilter(),
  );

  static final _loggerInfo = Logger(
    printer: PrettyPrinter(methodCount: 0, dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart),
    filter: CustomFilter(),
  );

  static final _loggerDebug = Logger(
    printer: PrettyPrinter(methodCount: 0, dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart),
    filter: CustomFilter(),
  );

  static final _loggerTrace = Logger(
    printer: PrettyPrinter(methodCount: 0, printEmojis: false, noBoxingByDefault: true),
    filter: CustomFilter(),
  );

  static String _getFormattedTime(DateTime time) {
    String threeDigits(int digits) {
      if (digits >= 100) return '$digits';
      if (digits >= 10) return '0$digits';
      return '00$digits';
    }

    String twoDigits(int digits) {
      if (digits >= 10) return '$digits';
      return '0$digits';
    }

    final now = time;
    final hours = twoDigits(now.hour);
    final minutes = twoDigits(now.minute);
    final seconds = twoDigits(now.second);
    final ms = threeDigits(now.millisecond);
    return '$hours:$minutes:$seconds.$ms';
  }

  static void logFailure(String message) {
    _loggerFailure.log(Level.error, message, time: DateTime.now());
  }

  static void logInfo(String message) {
    _loggerInfo.log(Level.info, message, time: DateTime.now());
  }

  static void logDebug(String message) {
    _loggerDebug.log(Level.debug, '${_getFormattedTime(DateTime.now())} --- $message');
  }

  static void logTrace(String message) {
    _loggerTrace.log(Level.trace, '${_getFormattedTime(DateTime.now())} --- $message');
  }
}

/// To display logs on release and debug mode
class CustomFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}