part of 'in_app_notification_provider.dart';

enum InAppNotificationType {
  warning,
  success,
}

class InAppNotificationData {
  final int id;
  final String message;
  final InAppNotificationType type;
  final bool isImportant;

  const InAppNotificationData({
    required this.id,
    required this.message,
    required this.type,
    this.isImportant = false,
  });

  factory InAppNotificationData.warning({
    required String message,
    bool isImportant = false,
  }) {
    return InAppNotificationData(
      id: DateTime.now().hashCode,
      message: message,
      type: InAppNotificationType.warning,
      isImportant: isImportant,
    );
  }

  factory InAppNotificationData.success({
    required String message,
    bool isImportant = false,
  }) {
    return InAppNotificationData(
      id: DateTime.now().hashCode,
      message: message,
      type: InAppNotificationType.success,
      isImportant: isImportant,
    );
  }

  bool isSameNotification(InAppNotificationData? compare) {
    return id == compare?.id && message == compare?.message && type == compare?.type && isImportant == compare?.isImportant;
  }
}
