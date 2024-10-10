import 'package:flutter/material.dart';

import '../../common.dart';
import '../../injection_container.dart';

part 'in_app_notification_data.dart';
part 'in_app_notification_widget.dart';

class InAppNotificationProvider with ChangeNotifier {
  final _inAppNotifications = <InAppNotificationData>[];

  InAppNotificationData? get notification => _inAppNotifications.isNotEmpty ? _inAppNotifications[0] : null;

  void addNotification(InAppNotificationData notification) {
    LoggerService.logTrace('InAppNotificationProvider -> addNotification()');
    bool isNeedNotify = _inAppNotifications.isEmpty;

    if (notification.isImportant) {
      _inAppNotifications.clear();
      isNeedNotify = true;
    }

    _inAppNotifications.add(notification);
    if (isNeedNotify) {
      notifyListeners();
    }
  }

  void addManyNotification(List<InAppNotificationData> notifications) {
    LoggerService.logTrace('InAppNotificationProvider -> addManyNotification()');
    for (final notification in notifications) {
      addNotification(notification);
    }
  }

  void removeNotification(InAppNotificationData notification) {
    LoggerService.logTrace('InAppNotificationProvider -> removeNotification()');
    _inAppNotifications.remove(notification);
    notifyListeners();
  }

  void clear() {
    LoggerService.logTrace('InAppNotificationProvider -> clear()');
    _inAppNotifications.clear();
    notifyListeners();
  }
}
