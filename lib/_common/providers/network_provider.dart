part of '../common.dart';

class NetworkProvider with ChangeNotifier {
  final _connectivity = Connectivity();
  bool _isConnected = false;

  bool get isConnected => _isConnected;
  
  Future<void> init() async {
    LoggerService.logTrace('NetworkProvider -> init()');
    final initialConnections = await _connectivity.checkConnectivity();
    if (initialConnections.isContainsAtLeastOne([ConnectivityResult.wifi, ConnectivityResult.ethernet, ConnectivityResult.mobile])) {
      _isConnected = true;
      notifyListeners();
    }

    _connectivity.onConnectivityChanged.listen((events) {
      final isConnected = events.isContainsAtLeastOne([ConnectivityResult.wifi, ConnectivityResult.ethernet, ConnectivityResult.mobile]);
      if (_isConnected != isConnected) {
        LoggerService.logTrace('NetworkProvider -> onConnectivityChanged(isConnected: $isConnected)');
        _isConnected = isConnected;
        notifyListeners();
      }
    });
  }
}