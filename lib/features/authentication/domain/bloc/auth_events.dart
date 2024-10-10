part of 'auth_bloc.dart';

abstract class AuthBlocEvent {
  const AuthBlocEvent([List props = const []]) : super();
}

class UpdateAuthStateEvent extends AuthBlocEvent {
  final AuthStateType stateEvent;

  UpdateAuthStateEvent({
    required this.stateEvent,
  }) : super([stateEvent]);
}

class SignOutAuthEvent extends AuthBlocEvent {
  SignOutAuthEvent() : super();
}
