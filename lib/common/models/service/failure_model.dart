import '../../../constants/failures.dart';

/// This model is used to describe and separate in app errors (bad http response or app error)
abstract class Failure {
  final String message;

  const Failure(this.message) : super();
}

class CommonFailure extends Failure {
  const CommonFailure({
    required String message,
  }) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure() : super('No Internet connection');
}

class HTTPFailure extends Failure {
  final String? comment;
  final HttpErrorType type;

  const HTTPFailure({
    required String message,
    this.comment,
    this.type = HttpErrorType.none,
  }) : super(message);
}
