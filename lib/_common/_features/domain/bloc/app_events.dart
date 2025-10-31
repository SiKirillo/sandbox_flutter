part of '../../../common.dart';

abstract class AppBlocEvent{}

/// Common
class Init_AppEvent extends AppBlocEvent {}

class UpdateStatus_AppEvent extends AppBlocEvent {
  final AppStatus status;

  UpdateStatus_AppEvent({
    required this.status,
  });
}

/// Service
class Reset_AppEvent extends AppBlocEvent {
  final bool isSessionExpired;

  Reset_AppEvent({
    this.isSessionExpired = false,
  });
}

class HandleFailure_AppEvent extends AppBlocEvent {}