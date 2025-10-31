import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';

import '../../../common.dart';
import '../../../services/logger/logger_service.dart';

part 'in_app_slider_builder.dart';

class InAppSliderProvider with ChangeNotifier {
  int _index = 0;
  int _length = 0;

  int get index => _index;
  int get length => _length;

  void init({int initialIndex = 0, int length = 1}) {
    assert(initialIndex >= 0 && length >= 1);

    _index = initialIndex;
    _length = length;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void update({int? index}) {
    LoggerService.logTrace('InAppSliderProvider -> update(index: $index)');
    if (_index == index) {
      return;
    }

    _index = index ?? _index;
    notifyListeners();
  }
}
