part of '../common.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;
  Brightness _brightness = Brightness.light;

  ThemeMode get mode => _mode;
  bool get isLight => _mode == ThemeMode.light || (_mode == ThemeMode.system && _brightness == Brightness.light);

  void init({required ThemeMode? mode, required Brightness? brightness}) {
    LoggerService.logTrace('ThemeProvider -> init(mode: $mode, brightness: $brightness)');
    _mode = mode ?? _mode;
    _brightness = brightness ?? _brightness;
  }

  void update({ThemeMode? mode, Brightness? brightness}) {
    LoggerService.logTrace('ThemeProvider -> update(mode: $mode, brightness: $brightness)');
    bool isNeedNotify = false;

    if (_mode != mode && mode != null) {
      _mode = mode;
      isNeedNotify = true;
    }

    if (_brightness != brightness && brightness != null) {
      _brightness = brightness;
      isNeedNotify = true;
    }

    if (isNeedNotify) {
      notifyListeners();
    }
  }
}
