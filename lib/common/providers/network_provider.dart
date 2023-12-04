import 'package:flutter/material.dart';

import '../services/logger_service.dart';

class NetworkProvider with ChangeNotifier {
  bool _isConnected = true;

  bool get isConnected => _isConnected;

  void update({bool? isConnected}) {
    LoggerService.logDebug('NetworkProvider -> update(isConnected: $isConnected)');
    if (_isConnected == isConnected) {
      return;
    }

    _isConnected = isConnected ?? _isConnected;
    notifyListeners();
  }
}
