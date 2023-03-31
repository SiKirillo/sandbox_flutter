import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:sandbox_flutter/common/bloc/core_bloc.dart';

import '../../injection_container.dart';
import '../models/in_app_failure_model.dart';
import '../models/service/failure_model.dart';
import '../usecases/core_update_in_app_failure.dart';
import '../usecases/core_update_settings.dart';
import 'logger_service.dart';

class NetworkListenerService {
  final _connectivity = Connectivity();
  bool _isConnected = true;

  void listenNetworkChanges() {
    LoggerService.logDebug('NetworkListenerService -> listenNetworkChanges()');
    _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.bluetooth) {
        return;
      }

      final isConnected = event != ConnectivityResult.none && event != ConnectivityResult.other && event != ConnectivityResult.bluetooth;
      if (_isConnected != isConnected) {
        _isConnected = isConnected;
        locator<CoreUpdateSettings>().call(CoreSettingsData(
          isNetworkEnabled: isConnected,
        ));
      }
    });
  }

  Future<bool> checkNetworkConnection(Future<Either<Failure, dynamic>> Function()? onErrorCallback) async {
    bool isNetworkEnabled = (await _connectivity.checkConnectivity()) != ConnectivityResult.none;
    if (isNetworkEnabled) return true;

    await Future.delayed(const Duration(seconds: 5));
    isNetworkEnabled = (await _connectivity.checkConnectivity()) != ConnectivityResult.none;

    if (!isNetworkEnabled) {
      LoggerService.logDebug('FAILURE: NetworkListenerService -> checkNetworkConnection()');
      if (onErrorCallback != null) {
        await locator<CoreUpdateInAppFailure>().call(InAppFailureData(
          onError: onErrorCallback,
          isImportant: true,
        ));
      }
    }

    return isNetworkEnabled;
  }
}