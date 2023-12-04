import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/images.dart';
import '../../../constants/sizes.dart';
import '../../../constants/style.dart';
import '../../../injection_container.dart';
import '../../widgets/texts.dart';
import '../logger_service.dart';

part 'in_app_notification_data.dart';
part 'in_app_notification_widget.dart';

class InAppNotificationProvider with ChangeNotifier {
  final _inAppNotifications = <InAppNotificationData>[];

  InAppNotificationData? get notification => _inAppNotifications.isNotEmpty ? _inAppNotifications[0] : null;

  void addNotification(InAppNotificationData notification) {
    LoggerService.logDebug('InAppNotificationProvider -> addNotification()');
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
    LoggerService.logDebug('InAppNotificationProvider -> addManyNotification()');
    for (final notification in notifications) {
      addNotification(notification);
    }
  }

  void removeNotification(InAppNotificationData notification) {
    LoggerService.logDebug('InAppNotificationProvider -> removeNotification()');
    _inAppNotifications.remove(notification);
    notifyListeners();
  }

  void clear() {
    LoggerService.logDebug('InAppNotificationProvider -> clear()');
    _inAppNotifications.clear();
    notifyListeners();
  }
}
