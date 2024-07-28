part of 'core_bloc.dart';

abstract class CoreBlocEvent {
  const CoreBlocEvent([List props = const []]) : super();
}

class SignOutCoreEvent extends CoreBlocEvent {
  SignOutCoreEvent() : super();
}
