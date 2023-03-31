import 'package:flutter/material.dart';

import '../services/logger_service.dart';

class CharlesProvider with ChangeNotifier {
  bool _isEnabled = false;

  bool get isEnabled => _isEnabled;

  void update(bool isEnabled) {
    LoggerService.logDebug('CharlesProvider -> update(isEnabled: $isEnabled)');
    if (_isEnabled == isEnabled) {
      return;
    }

    _isEnabled = isEnabled;
    notifyListeners();
  }
}
