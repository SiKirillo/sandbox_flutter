import 'package:flutter/material.dart';

import '../services/logger_service.dart';

class CharlesProvider with ChangeNotifier {
  bool _isEnabled = false;
  String _proxyIP = 'localhost:8888';

  bool get isEnabled => _isEnabled;
  String get proxyIP => _proxyIP;

  void update({bool? isEnabled, String? proxyIP}) {
    LoggerService.logDebug('CharlesProvider -> update(isEnabled: $isEnabled, proxyIP: $proxyIP)');
    if (_isEnabled == isEnabled && _proxyIP == proxyIP) {
      return;
    }

    _isEnabled = isEnabled ?? _isEnabled;
    _proxyIP = proxyIP ?? _proxyIP;
    notifyListeners();
  }
}
