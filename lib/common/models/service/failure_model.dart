part of '../../common.dart';

abstract class Failure {
  final String message;
  final String? comment;

  const Failure({
    required this.message,
    this.comment,
  }) : super();
}

class CommonFailure extends Failure {
  const CommonFailure({
    required super.message,
  }) : super(comment: null);
}

class HttpFailure extends Failure {
  const HttpFailure({
    required super.message,
    super.comment,
  });
}

class NetworkFailure extends Failure {
  NetworkFailure() : super(
    message: 'errors.other.no_internet'.tr(),
    comment: null,
  );
}

class AuthFailure extends Failure {
  final AuthFailureType type;

  const AuthFailure({
    required super.message,
    required this.type,
  }) : super(comment: null);
}

class BiometricFailure extends Failure {
  final BiometricFailureType type;

  const BiometricFailure({
    required super.message,
    required this.type,
  }) : super(comment: null);
}