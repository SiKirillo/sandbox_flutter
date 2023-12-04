part of 'auth_bloc.dart';

enum AuthStatusType {
  unauthenticated,
  authenticated,
}

class AuthState {
  final UserData? userData;
  final TokensAuthData? tokensData;
  final AuthStatusType authStatusType;

  const AuthState({
    required this.userData,
    required this.tokensData,
    required this.authStatusType,
  });

  factory AuthState.initial() {
    return const AuthState(
      userData: null,
      tokensData: null,
      authStatusType: AuthStatusType.unauthenticated,
    );
  }

  AuthState copyWith({
    UserData? userData,
    TokensAuthData? tokensData,
    AuthStatusType? authStatusType,
  }) {
    return AuthState(
      userData: userData ?? this.userData,
      tokensData: tokensData ?? this.tokensData,
      authStatusType: authStatusType ?? this.authStatusType,
    );
  }
}
