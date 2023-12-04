part of 'in_app_toast_provider.dart';

enum InAppToastType {
  warning,
  network,
}

class InAppToastData {
  final int id;
  final ValueKey<String> key;
  final InAppToastType type;
  final String message;

  const InAppToastData({
    required this.id,
    required this.key,
    required this.type,
    required this.message,
  });

  factory InAppToastData.create({
    required ValueKey<String> key,
    required String message,
  }) {
    return InAppToastData(
      id: DateTime.now().hashCode,
      key: key,
      type: InAppToastType.warning,
      message: message,
    );
  }

  factory InAppToastData.failure({
    required ValueKey<String> key,
    required Failure failure,
  }) {
    if (failure is NetworkFailure) {
      return InAppToastData(
        id: DateTime.now().hashCode,
        key: key,
        type: InAppToastType.network,
        message: failure.message,
      );
    }

    return InAppToastData(
      id: DateTime.now().hashCode,
      key: key,
      type: InAppToastType.warning,
      message: failure.message,
    );
  }

  bool isSameToast(InAppToastData? compare) {
    return id == compare?.id && key == compare?.key && type == compare?.type && message == compare?.message;
  }
}
