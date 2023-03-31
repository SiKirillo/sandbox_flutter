import '../common/models/service/failure_model.dart';

enum HttpErrorType {
  none,
}

extension HttpErrorExtension on HttpErrorType {
  static HTTPFailure getErrorByCode(int? code, String? comment) {
    switch (code) {
      case 400: {
        return HTTPFailure(
          message: 'Auth failure',
          comment: comment,
          type: HttpErrorType.none,
        );
      }

      case 401: {
        return HTTPFailure(
          message: 'Auth failure',
          comment: comment,
          type: HttpErrorType.none,
        );
      }

      case 409: {
        return HTTPFailure(
          message: 'Conflict failure',
          comment: comment,
          type: HttpErrorType.none,
        );
      }

      case 422: {
        return HTTPFailure(
          message: 'Validation failure',
          comment: comment,
          type: HttpErrorType.none,
        );
      }

      default: {
        return HTTPFailure(
          message: 'Unknown failure',
          comment: comment,
          type: HttpErrorType.none,
        );
      }
    }
  }
}