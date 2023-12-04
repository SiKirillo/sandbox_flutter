import 'dart:async';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:provider/provider.dart';
import 'package:sandbox_flutter/common/widgets/dialogs/warning_dialog.dart';

import '../../../constants/colors.dart';
import '../../../constants/images.dart';
import '../../../constants/sizes.dart';
import '../../../constants/style.dart';
import '../../../injection_container.dart';
import '../../utilities/dialogs_util.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/buttons/base_button.dart';
import '../../widgets/texts.dart';
import '../../widgets/wrappers/opacity_wrapper.dart';
import '../logger_service.dart';

part 'in_app_failure_data.dart';
part 'in_app_failure_widget.dart';

class InAppFailureProvider with ChangeNotifier {
  final _inProgressEvents = <String>[];
  final _inAppFailures = <InAppFailureData>[];
  final _inAppFailureOptions = <InAppFailureOptions>[];

  InAppFailureType? _primaryType;
  bool _isProcessing = false;

  bool get isShowing => isHaveFailures || _isProcessing;
  bool get isHaveFailures => _inProgressEvents.isEmpty && _inAppFailures.isNotEmpty;
  bool get isImportant => _inAppFailureOptions.map((option) => option.isImportant).contains(true);

  InAppFailureType? get primaryType {
    final types = _inAppFailures.map((failure) => failure.type).toList();
    types.sort((a, b) => a.index.compareTo(b.index));
    return _primaryType ?? (types.isNotEmpty ? types[0] : null);
  }

  InAppFailureOptions? get primaryOptions {
    return _inAppFailureOptions.firstWhereOrNull((option) => option.type == primaryType?.toExtended());
  }

  void addEvent(String event) {
    final isNeedNotify = _inProgressEvents.isEmpty;
    _inProgressEvents.add(event);

    if (isNeedNotify) {
      notifyListeners();
    }
  }

  void removeEvent(String event) {
    _inProgressEvents.remove(event);
    final isNeedNotify = _inProgressEvents.isEmpty;

    if (isNeedNotify) {
      notifyListeners();
    }
  }

  void addOptions(InAppFailureOptions options) {
    if (_inAppFailureOptions.map((option) => option.type).contains(options.type)) {
      _inAppFailureOptions.removeWhere((option) => option.type == options.type);
    }
    _inAppFailureOptions.add(options);
  }

  void addFailure(InAppFailureData failure, {InAppFailureOptions? options}) {
    LoggerService.logDebug('InAppFailureProvider -> addFailure()');
    _inAppFailures.add(failure);
    if (options != null) {
      addOptions(options);
    }
  }

  void clear() {
    LoggerService.logDebug('InAppFailureProvider -> clear()');
    _inProgressEvents.clear();
    _inAppFailures.clear();
    _inAppFailureOptions.clear();
    notifyListeners();
  }

  Future<void> processAllFailures() async {
    LoggerService.logDebug('InAppFailureProvider -> processAllFailures()');
    final failures = _inAppFailures.map((e) => e.onError).toList();
    _primaryType = primaryType;
    _isProcessing = true;

    _inAppFailures.clear();
    await Future.wait(failures.map((e) => e()));

    _isProcessing = false;
    _primaryType = null;
    notifyListeners();

    if (_inAppFailures.isEmpty) {
      _inAppFailureOptions.clear();
    }
  }
}
