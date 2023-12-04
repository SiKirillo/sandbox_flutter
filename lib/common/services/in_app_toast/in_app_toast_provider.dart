import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/style.dart';
import '../../../injection_container.dart';
import '../../models/service/failure_model.dart';
import '../../widgets/texts.dart';
import '../logger_service.dart';

part 'in_app_toast_data.dart';
part 'in_app_toast_widget.dart';

class InAppToastProvider with ChangeNotifier {
  InAppToastData? _inAppToast;

  InAppToastData? get toast => _inAppToast;

  void addToast(InAppToastData toast) {
    LoggerService.logDebug('InAppToastProvider -> addToast()');
    _inAppToast = toast;
    notifyListeners();
  }

  void removeToast(InAppToastData toast) {
    LoggerService.logDebug('InAppToastProvider -> removeToast()');
    if (_inAppToast?.isSameToast(toast) == true) {
      _inAppToast = null;
      notifyListeners();
    }
  }

  void clear() {
    LoggerService.logDebug('InAppToastProvider -> clear()');
    _inAppToast = null;
    notifyListeners();
  }
}
