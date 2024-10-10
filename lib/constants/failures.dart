part of '../common/common.dart';

enum AuthFailureType {
  none,
}

extension AuthFailureExtension<T> on AuthFailureType {
  AuthFailure get() {
    switch (this) {
      default:
        return AuthFailure(
          message: 'errors.other.error'.tr(),
          type: AuthFailureType.none,
        );
    }
  }
}

enum HttpFailureType {
  none,
}

extension HttpFailureExtension<T> on HttpFailureType {
  static HttpFailure get(int? code) {
    switch (code) {
      default:
        return HttpFailure(
          message: 'errors.other.error'.tr(),
          comment: 'comment',
        );
    }
  }
}

enum BiometricFailureType {
  biometricToManyAttempts,
  biometricToManyAttemptsDelay,
  biometricCanceled,
  biometricIncorrect,
  biometricUnsupported,
  biometricBlocked,
  none,
}

extension BiometricFailureExtension<T> on BiometricFailureType {
  BiometricFailure get() {
    switch (this) {
      default:
        return BiometricFailure(
          message: 'errors.other.error'.tr(),
          type: BiometricFailureType.none,
        );
    }
  }
}