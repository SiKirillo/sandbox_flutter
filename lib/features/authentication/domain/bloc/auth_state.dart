part of 'auth_bloc.dart';

enum AuthStatusType {
  unauthenticated,
  authenticated,
}

class AuthState {
  final UserData? userData;
  final AuthStatusType authStatusType;

  const AuthState({
    required this.authStatusType,
    required this.userData,
  });

  factory AuthState.initial() {
    return const AuthState(
      userData: null,
      authStatusType: AuthStatusType.unauthenticated,
    );
  }

  AuthState update({
    UserData? userData,
    AuthStatusType? authStatusType,
  }) {
    return AuthState(
      userData: userData ?? this.userData,
      authStatusType: authStatusType ?? this.authStatusType,
    );
  }
}
