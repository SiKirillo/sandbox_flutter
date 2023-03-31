part of 'core_bloc.dart';

abstract class CoreBlocEvent {
  const CoreBlocEvent([List props = const []]) : super();
}

class UpdateCoreInAppNotificationEvent extends CoreBlocEvent {
  final InAppNotificationData? data;

  UpdateCoreInAppNotificationEvent({
    required this.data,
  }) : super([data]);
}

class UpdateCoreInAppFailureEvent extends CoreBlocEvent {
  final InAppFailureData? data;

  UpdateCoreInAppFailureEvent({
    required this.data,
  }) : super([data]);
}

class UpdateCoreInAppToastEvent extends CoreBlocEvent {
  final InAppToastData? data;

  UpdateCoreInAppToastEvent({
    required this.data,
  }) : super([data]);
}

class SignOutCoreEvent extends CoreBlocEvent {
  SignOutCoreEvent() : super();
}
