part of 'auth_bloc.dart';

abstract class AuthBlocEvent {
  const AuthBlocEvent([List props = const []]) : super();
}

class SignInEvent extends AuthBlocEvent {
  final UserData userData;

  SignInEvent({
    required this.userData,
  }) : super([userData]);
}

class UpdateAuthStatusEvent extends AuthBlocEvent {
  final AuthStatusType authType;

  UpdateAuthStatusEvent({
    required this.authType,
  }) : super([authType]);
}

class UpdateTokensDataEvent extends AuthBlocEvent {
  final TokensAuthData tokensData;

  UpdateTokensDataEvent({
    required this.tokensData,
  }) : super([tokensData]);
}

class SignOutAuthEvent extends AuthBlocEvent {
  SignOutAuthEvent() : super();
}
