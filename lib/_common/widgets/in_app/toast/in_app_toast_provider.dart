import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common.dart';
import '../../../services/logger/logger_service.dart';

part 'in_app_toast_data.dart';
part 'in_app_toast_builder.dart';

class InAppToastProvider with ChangeNotifier {
  InAppToastData? _inAppToast;
  InAppToastData? get toast => _inAppToast;

  void addToast(InAppToastData toast) {
    LoggerService.logTrace('InAppToastProvider -> addToast()');
    InAppToastData formattedToast = toast;

    if (formattedToast.description == null || formattedToast.description.toString().isEmpty) {
      LoggerService.logWarning('InAppToastProvider -> addToast(): toast description is empty');
      formattedToast = InAppToastData(
        id: formattedToast.id,
        key: formattedToast.key,
        description: 'errors.other.none'.tr(),
      );
    }

    _inAppToast = formattedToast;
    notifyListeners();
  }

  void removeToast(InAppToastData toast) {
    LoggerService.logTrace('InAppToastProvider -> removeToast()');
    if (_inAppToast?.isEqual(toast) == true) {
      _inAppToast = null;
      notifyListeners();
    }
  }

  void clear() {
    LoggerService.logTrace('InAppToastProvider -> clear()');
    _inAppToast = null;
    notifyListeners();
  }
}
