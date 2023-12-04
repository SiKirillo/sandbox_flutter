part of 'in_app_notification_provider.dart';

enum InAppNotificationType {
  warning,
  success,
}

class InAppNotificationData {
  final int id;
  final InAppNotificationType type;
  final String message;
  final bool isImportant;

  const InAppNotificationData({
    required this.id,
    required this.type,
    required this.message,
    this.isImportant = false,
  });

  factory InAppNotificationData.warning({
    required String message,
    bool isImportant = false,
  }) {
    return InAppNotificationData(
      id: DateTime.now().hashCode,
      type: InAppNotificationType.warning,
      message: message,
      isImportant: isImportant,
    );
  }

  factory InAppNotificationData.success({
    required String message,
    bool isImportant = false,
  }) {
    return InAppNotificationData(
      id: DateTime.now().hashCode,
      type: InAppNotificationType.success,
      message: message,
      isImportant: isImportant,
    );
  }

  bool isSameNotification(InAppNotificationData? compare) {
    return id == compare?.id && type == compare?.type && message == compare?.message && isImportant == compare?.isImportant;
  }
}
