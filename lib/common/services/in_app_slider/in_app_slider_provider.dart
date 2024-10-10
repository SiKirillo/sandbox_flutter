import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../common.dart';
import '../../injection_container.dart';

part 'in_app_slider_data.dart';
part 'in_app_slider_widget.dart';

class InAppSliderProvider with ChangeNotifier {
  int _currentPage = 0;
  int _maxPage = 0;

  int get currentPage => _currentPage;
  int get maxPage => _maxPage;

  void init({int initialPage = 0, int maxPage = 0}) {
    assert(initialPage >= 0 && maxPage >= 0);

    _currentPage = initialPage;
    _maxPage = maxPage;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void update({int? currentPage}) {
    LoggerService.logDebug('InAppSliderProvider -> update(currentPage: $currentPage)');
    if (_currentPage == currentPage) {
      return;
    }

    _currentPage = currentPage ?? _currentPage;
    notifyListeners();
  }
}
