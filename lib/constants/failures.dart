part of '../_common/common.dart';

/// Common
class CommonFailure extends Failure {
  const CommonFailure({
    required super.message,
    super.comment,
  });
}

/// Network
class NetworkFailure extends Failure {
  NetworkFailure() : super(
    message: 'errors.other.no_internet'.tr(),
    comment: null,
  );
}

/// Http
class HttpFailure extends Failure {
  final String? errorCode;

  const HttpFailure({
    required super.message,
    super.comment,
    this.errorCode,
  });

  static HttpFailure get({
    required String requestUrl,
    required String requestMethod,
    required int? statusCode,
    String? errorCode,
    String? errorMessage,
  }) {
    final errorId = 'errors.http.$requestUrl.${requestMethod.toLowerCase()}.$statusCode${errorCode != null ? '.$errorCode' : ''}';
    final errorTranslation = errorId.tr();

    if (statusCode != null && statusCode >= 500) {
      String? message;

      if (statusCode <= 504) {
        message = 'errors.http.server_errors.$statusCode'.tr();
      }

      return HttpFailure(message: message ?? 'errors.http.server_errors.5xx'.tr());
    }

    /// If there is no translation of the error
    if (errorId == errorTranslation) {
      return HttpFailure(
        message: errorMessage ?? 'errors.other.none'.tr(),
      );
    }

    return HttpFailure(
      message: errorTranslation,
      errorCode: errorCode,
    );
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

class BiometricFailure extends Failure {
  const BiometricFailure({
    required super.message,
    super.comment,
  });
}

extension BiometricFailureExtension<T> on BiometricFailureType {
  BiometricFailure get() {
    switch (this) {
      default:
        return BiometricFailure(
          message: 'errors.other.error'.tr(),
        );
    }
  }
}