part of 'in_app_toast_provider.dart';

enum InAppToastType {
  warning,
  network,
}

class InAppToastData {
  final int id;
  final ValueKey<String> key;
  final InAppToastType type;
  final String comment;

  const InAppToastData({
    required this.id,
    required this.key,
    required this.type,
    required this.comment,
  });

  factory InAppToastData.message({
    required ValueKey<String> key,
    required String comment,
  }) {
    return InAppToastData(
      id: DateTime.now().hashCode,
      key: key,
      type: InAppToastType.warning,
      comment: comment,
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
        comment: failure.message,
      );
    }

    return InAppToastData(
      id: DateTime.now().hashCode,
      key: key,
      type: InAppToastType.warning,
      comment: failure.message,
    );
  }

  bool isSameToast(InAppToastData? compare) {
    return id == compare?.id && key == compare?.key && type == compare?.type && comment == compare?.comment;
  }
}
