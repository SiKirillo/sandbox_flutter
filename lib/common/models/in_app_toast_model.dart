import 'package:flutter/material.dart';

import 'service/failure_model.dart';

enum InAppToastType {
  info,
  network,
}

class InAppToastData {
  final int id;
  final ValueKey key;
  final String message;
  final InAppToastType type;

  const InAppToastData({
    required this.id,
    required this.key,
    required this.message,
    this.type = InAppToastType.info,
  });

  factory InAppToastData.create({
    required ValueKey key,
    required String message,
  }) {
    return InAppToastData(
      id: DateTime.now().hashCode,
      key: key,
      message: message,
      type: InAppToastType.info,
    );
  }

  factory InAppToastData.createFromFailure({
    required ValueKey key,
    required Failure failure,
  }) {
    if (failure is HTTPFailure) {
      return InAppToastData(
        id: DateTime.now().hashCode,
        key: key,
        message: failure.comment ?? failure.message,
        type: InAppToastType.info,
      );
    }

    if (failure is NetworkFailure) {
      return InAppToastData(
        id: DateTime.now().hashCode,
        key: key,
        message: failure.message,
        type: InAppToastType.network,
      );
    }

    return InAppToastData(
      id: DateTime.now().hashCode,
      key: key,
      message: failure.message,
      type: InAppToastType.info,
    );
  }
}
