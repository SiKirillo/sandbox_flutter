enum InAppNotificationType {
  warning,
  success,
  none,
}

class InAppNotificationData {
  final int id;
  final String message;
  final InAppNotificationType type;

  const InAppNotificationData({
    required this.id,
    required this.message,
    this.type = InAppNotificationType.none,
  });

  InAppNotificationData empty() {
    return InAppNotificationData(
      id: DateTime.now().hashCode,
      message: '',
    );
  }

  factory InAppNotificationData.createWarning({
    required String message,
  }) {
    return InAppNotificationData(
      id: DateTime.now().hashCode,
      message: message,
      type: InAppNotificationType.warning,
    );
  }

  factory InAppNotificationData.createSuccess({
    required String message,
  }) {
    return InAppNotificationData(
      id: DateTime.now().hashCode,
      message: message,
      type: InAppNotificationType.success,
    );
  }
}
