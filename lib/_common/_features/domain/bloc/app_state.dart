part of '../../../common.dart';

enum AppStatus {
  splash,
  welcome,
  loggedIn,
  loggedOut,
}

class AppState extends BlocState {
  final AppStatus status;

  const AppState({
    required this.status,
    super.isLocked = false,
    super.isReady = false,
  });

  factory AppState.initial() {
    return AppState(
      status: AppStatus.splash,
    );
  }

  AppState signOut() {
    return AppState(
      status: AppStatus.loggedOut,
    );
  }

  AppState sessionExpired() {
    return AppState(
      status: AppStatus.welcome,
    );
  }

  @override
  AppState copyWith({
    AppStatus? status,
    bool? isLocked,
    bool? isReady,
  }) {
    return AppState(
      status: status ?? this.status,
      isLocked: isLocked ?? this.isLocked,
      isReady: isReady ?? this.isReady,
    );
  }

  @override
  AppState copyWithForced() => this;
}