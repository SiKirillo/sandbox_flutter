import '../common/models/service/failure_model.dart';

enum AuthErrorType {
  userNoFound,
  userDisabled,
  emailAlreadyInUse,
  badCredentials,
  none,
}

extension AuthErrorExtension on AuthErrorType {
  static AuthFailure getErrorByCode(String code) {
    switch (code) {
      case 'user-not-found': {
        return const AuthFailure(
          message: 'No user found for that email',
          type: AuthErrorType.userDisabled,
        );
      }

      case 'user-disabled': {
        return const AuthFailure(
          message: 'Account disabled for that email',
          type: AuthErrorType.userDisabled,
        );
      }

      case 'email-already-in-use': {
        return const AuthFailure(
          message: 'Account already exists for that email',
          type: AuthErrorType.emailAlreadyInUse,
        );
      }

      case 'invalid-email': {
        return const AuthFailure(
          message: 'Wrong credentials',
          type: AuthErrorType.badCredentials,
        );
      }

      case 'wrong-password': {
        return const AuthFailure(
          message: 'Wrong credentials',
          type: AuthErrorType.badCredentials,
        );
      }

      default: {
        return const AuthFailure(
          message: 'Unknown failure',
          type: AuthErrorType.none,
        );
      }
    }
  }
}

enum HttpErrorType {
  none,
  badAuthTokens,
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