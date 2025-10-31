part of 'logger_service.dart';

class LoggerProvider with ChangeNotifier {
  bool _isOpened = false;
  bool get isOpened => _isOpened;

  void _open() {
    _isOpened = true;
    notifyListeners();
  }

  void _close() {
    _isOpened = false;
    notifyListeners();
  }
}