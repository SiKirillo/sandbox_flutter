import 'package:flutter/material.dart';

import '../../common.dart';
import '../../injection_container.dart';

part 'in_app_toast_data.dart';
part 'in_app_toast_widget.dart';

class InAppToastProvider with ChangeNotifier {
  InAppToastData? _inAppToast;

  InAppToastData? get toast => _inAppToast;

  void addToast(InAppToastData toast) {
    LoggerService.logTrace('InAppToastProvider -> addToast()');
    _inAppToast = toast;
    notifyListeners();
  }

  void removeToast(InAppToastData toast) {
    LoggerService.logTrace('InAppToastProvider -> removeToast()');
    if (_inAppToast?.isSameToast(toast) == true) {
      _inAppToast = null;
      notifyListeners();
    }
  }

  void clear() {
    LoggerService.logTrace('InAppToastProvider -> clear()');
    _inAppToast = null;
    notifyListeners();
  }
}
