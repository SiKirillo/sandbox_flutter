part of '../common.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;
  Brightness _brightness = Brightness.light;

  ThemeMode get mode => _mode;
  Brightness get brightness => _brightness;
  bool get isLight => _mode == ThemeMode.light || (_mode == ThemeMode.system && _brightness == Brightness.light);

  void init({required ThemeMode? mode, required Brightness? brightness}) {
    LoggerService.logTrace('ThemeProvider -> init(mode: $mode, brightness: $brightness)');
    _mode = mode ?? _mode;
    _brightness = brightness ?? _brightness;
  }

  void update({ThemeMode? mode, Brightness? brightness}) {
    LoggerService.logTrace('ThemeProvider -> update(mode: $mode, brightness: $brightness)');
    if (_mode != mode && mode != null) {
      _mode = mode;
      notifyListeners();
    }

    if (_brightness != brightness && brightness != null) {
      _brightness = brightness;
      notifyListeners();
    }
  }
}
