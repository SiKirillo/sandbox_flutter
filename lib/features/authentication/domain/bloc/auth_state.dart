part of 'auth_bloc.dart';

enum AuthStateType {
  initialSession,
  welcome,
  signedIn,
  signedOut,
  passwordRecovery,
}

class AuthState {
  final AuthStateType stateEvent;

  const AuthState({
    required this.stateEvent,
  });

  factory AuthState.initial() {
    return const AuthState(
      stateEvent: AuthStateType.initialSession,
    );
  }

  factory AuthState.signOut() {
    return const AuthState(
      stateEvent: AuthStateType.welcome,
    );
  }

  AuthState copyWith({
    AuthStateType? stateEvent,
  }) {
    return AuthState(
      stateEvent: stateEvent ?? this.stateEvent,
    );
  }
}