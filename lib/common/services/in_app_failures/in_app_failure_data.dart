part of 'in_app_failure_provider.dart';

enum InAppFailureType {
  network,
  backend,
  web,
}

enum InAppFailureTypeExtended {
  network,
  backend,
  web,
}

extension InAppFailureTypeExtention on InAppFailureType {
  InAppFailureTypeExtended toExtended() {
    switch (this) {
      case InAppFailureType.network:
        return InAppFailureTypeExtended.network;

      case InAppFailureType.backend:
        return InAppFailureTypeExtended.backend;

      case InAppFailureType.web:
        return InAppFailureTypeExtended.web;
    }
  }

  String getTitle() {
    switch (this) {
      case InAppFailureType.network:
        return 'Lost connection';

      case InAppFailureType.backend:
        return 'Something went wrong';

      case InAppFailureType.web:
        return 'Ooops...';
    }
  }

  String getDescription() {
    switch (this) {
      case InAppFailureType.network:
        return 'Please check your internet connection and try again.';

      case InAppFailureType.backend:
        return 'Please try again later.';

      case InAppFailureType.web:
        return 'Please try again later.';
    }
  }

  String getButtonTitle() {
    switch (this) {
      case InAppFailureType.network:
        return 'Try again';

      case InAppFailureType.backend:
        return 'Try again';

      case InAppFailureType.web:
        return 'Try Later';
    }
  }
}

class InAppFailureData {
  final Function() onError;
  final InAppFailureType type;

  const InAppFailureData({
    required this.onError,
    required this.type,
  });

  factory InAppFailureData.network({required Function() onError}) {
    return InAppFailureData(
      onError: onError,
      type: InAppFailureType.network,
    );
  }

  factory InAppFailureData.backend({required Function() onError}) {
    return InAppFailureData(
      onError: onError,
      type: InAppFailureType.backend,
    );
  }

  factory InAppFailureData.webview({required Function() onError}) {
    return InAppFailureData(
      onError: onError,
      type: InAppFailureType.web,
    );
  }
}

class InAppFailureOptions {
  final InAppFailureTypeExtended type;
  final Function()? onGoBack;
  final Function()? onGoNext;
  final bool isImportant;

  const InAppFailureOptions({
    required this.type,
    this.onGoBack,
    this.onGoNext,
    this.isImportant = false,
  });
}