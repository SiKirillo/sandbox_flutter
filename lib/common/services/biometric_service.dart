part of '../common.dart';

enum BiometricSupportedType {
  face,
  fingerprint,
}

class BiometricService {
  final _localAuthentication = LocalAuthentication();
  Timer? _manyAttemptsTimer;
  bool _isInit = false;

  Future<dartz.Either<Failure, bool>> authenticate(String localizedReason) async {
    final isSupported = await canAuthenticate();
    if (!isSupported) {
      return dartz.Left(BiometricFailureType.biometricUnsupported.get());
    }

    try {
      final response = await _localAuthentication.authenticate(
        localizedReason: localizedReason,
        authMessages: [
          IOSAuthMessages(
            lockOut: BiometricFailureType.biometricBlocked.get().message,
          ),
        ],
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: false,
        ),
      );

      if (response) {
        _manyAttemptsTimer?.cancel();
        _manyAttemptsTimer == null;
        return dartz.Right(response);
      } else {
        return dartz.Left(BiometricFailureType.biometricCanceled.get());
      }
    } on PlatformException catch (e) {
      LoggerService.logDebug('BiometricService -> authenticate() PlatformException error: $e');
      if (e.code == 'LockedOut' || (e.message ?? '').contains('API is locked')) {
        if (_manyAttemptsTimer?.isActive ?? false || !_isInit) {
          return dartz.Left(BiometricFailureType.biometricToManyAttemptsDelay.get());
        }

        _manyAttemptsTimer = Timer(const Duration(seconds: 30), () {});
        return dartz.Left(BiometricFailureType.biometricToManyAttempts.get());
      }

      _manyAttemptsTimer?.cancel();
      _manyAttemptsTimer == null;

      if (e.code == 'PermanentlyLockedOut' || (e.message ?? '').contains('The operation was canceled because ERROR_LOCKOUT occurred too many times')) {
        return dartz.Left(BiometricFailureType.biometricBlocked.get());
      }

      if (e.code == 'Authentication canceled' || (e.message ?? '').contains('Authentication canceled')) {
        return dartz.Left(BiometricFailureType.biometricCanceled.get());
      }

      return dartz.Left(BiometricFailureType.biometricIncorrect.get());
    } catch (e) {
      LoggerService.logDebug('BiometricService -> authenticate() error: $e');
      _manyAttemptsTimer?.cancel();
      _manyAttemptsTimer == null;
      return dartz.Left(BiometricFailureType.biometricIncorrect.get());
    } finally {
      _isInit = true;
    }
  }

  Future<bool> canAuthenticate() async {
    final isSupported = await _localAuthentication.isDeviceSupported();
    final availableBiometrics = await _localAuthentication.getAvailableBiometrics();

    if (Platform.isAndroid) {
      return isSupported && availableBiometrics.isNotEmpty;
    }

    return isSupported;
  }

  Future<List<BiometricSupportedType>> getSupportedBiometrics() async {
    final availableBiometrics = await _localAuthentication.getAvailableBiometrics();
    return [
      if (availableBiometrics.contains(BiometricType.face))
        BiometricSupportedType.face,
      if (availableBiometrics.contains(BiometricType.fingerprint))
        BiometricSupportedType.fingerprint,
    ];
  }
}