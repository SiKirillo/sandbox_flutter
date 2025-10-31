part of '../common.dart';

abstract class BlocState {
  final bool isLocked;
  final bool isReady;

  const BlocState({
    required this.isLocked,
    required this.isReady,
  });

  BlocState copyWith();
  BlocState copyWithForced();
}

class BlocEventResponse<Failure, T> {
  final Function(Failure)? onFailure;
  final Function(T)? onResult;

  const BlocEventResponse({
    this.onFailure,
    this.onResult,
  });
}
