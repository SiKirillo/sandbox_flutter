part of '../common/common.dart';

class ImageConstants {
  static const svgPrefix = '.svg';
  static bool get _isLightTheme => locator<ThemeProvider>().isLight;

  static void precacheAssets(BuildContext context) {
    final svgLoaders = <SvgAssetLoader>[
      // const SvgAssetLoader(icLogo),
    ];

    for (final loader in svgLoaders) {
      svg.cache.putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
    }
  }

  /// Service
  static const icBack = 'assets/icons/ic_back.svg';
  static const icClose = 'assets/icons/ic_close.svg';
  static const icMore = 'assets/icons/ic_more.svg';
  static const icTextfieldEye = 'assets/icons/ic_textfield_eye.svg';
  static const icTextfieldOk = 'assets/icons/ic_textfield_ok.svg';

  /// Logo
  static const icLogo = 'assets/icons/ic_logo.png';
}