part of 'in_app_notification_provider.dart';

enum InAppNotificationType {
  warning,
  success,
}

class InAppNotificationData {
  final int id;
  final dynamic message;
  final InAppNotificationType type;
  final bool isImportant;

  const InAppNotificationData({
    required this.id,
    required this.message,
    required this.type,
    this.isImportant = false,
  }) : assert(message is Widget || message is String);

  factory InAppNotificationData.warning({
    required dynamic message,
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
    required dynamic message,
    bool isImportant = false,
  }) {
    return InAppNotificationData(
      id: DateTime.now().hashCode,
      message: message,
      type: InAppNotificationType.success,
      isImportant: isImportant,
    );
  }

  bool isEqual(InAppNotificationData? compare) {
    return id == compare?.id && message == compare?.message && type == compare?.type && isImportant == compare?.isImportant;
  }
}
