part of '../_common/common.dart';

class ImageConstants {
  static const svgPrefix = '.svg';

  static bool get _isLightTheme => locator<ThemeProvider>().isLight;

  static void precacheAssets(BuildContext context) {
    final svgLoaders = <SvgAssetLoader>[
      // const SvgAssetLoader(icBackground),
    ];

    for (final loader in svgLoaders) {
      svg.cache.putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
    }

    // precacheImage(AssetImage('something'), context);
  }

  /// Service
  static const icDropDown = 'assets/icons/_common/ic_drop_down.svg';
  static const icSearch = 'assets/icons/_common/ic_search.svg';
  static const icWarning = 'assets/icons/_common/ic_warning.svg';
  static const icSuccess = 'assets/icons/_common/ic_success.svg';
  static const icTextfieldEye = 'assets/icons/_common/ic_textfield_eye.svg';
  static const icTextfieldOk = 'assets/icons/_common/ic_textfield_ok.svg';
  static const icTextfieldClean = 'assets/icons/_common/ic_textfield_clean.svg';
  static const icClose = 'assets/icons/_common/ic_close.svg';
  static const icBack = 'assets/icons/_common/ic_back.svg';
  static const icPlus = 'assets/icons/_common/ic_plus.svg';
  static const icMinus = 'assets/icons/_common/ic_minus.svg';
  static const icMore = 'assets/icons/_common/ic_more.svg';
  static const icError = 'assets/icons/_common/ic_error.svg';
  static const icInfo = 'assets/icons/_common/ic_info.svg';
  static const icForward = 'assets/icons/_common/ic_forward.svg';

  static const icPermissionLocation = 'assets/icons/ic_permission_location.svg';
}
