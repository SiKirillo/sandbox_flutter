part of '../common/common.dart';

class ColorConstants {
  static final light = _LightColorTheme();
  static final dark = _DarkColorTheme();
  static bool get _isLightTheme => locator<ThemeProvider>().isLight;

  /// Service
  static const transparent = Color(0x00000000);
  static Color divider() => _isLightTheme ? light.divider : light.divider;
  static Color overlay() => _isLightTheme ? light.overlay : light.overlay;

  /// Background
  static Color scaffoldBG() => _isLightTheme ? light.scaffoldBG : light.scaffoldBG;
  static Color dialogsBG() => _isLightTheme ? light.dialogsBG : light.dialogsBG;

  /// Status bar
  static Color statusBarColor() => _isLightTheme ? light.statusBarColor : light.statusBarColor;

  /// App bar
  static Color appBarBG() => _isLightTheme ? light.appBarBG : light.appBarBG;

  /// Navigation bar
  static Color navigationBarShadowColor() => _isLightTheme ? light.navigationBarShadow : light.navigationBarShadow;
  static Color navigationBarActiveColor() => _isLightTheme ? light.navigationBarActiveItem : light.navigationBarActiveItem;
  static Color navigationBarDisableColor() => _isLightTheme ? light.navigationBarDisableItem : light.navigationBarDisableItem;

  /// Text
  static Color textBlack() => _isLightTheme ? light.textBlack : light.textBlack;
  static Color textGrey() => _isLightTheme ? light.textGrey : light.textGrey;
  static Color textWhite() => _isLightTheme ? light.textWhite : light.textWhite;
  static Color textBlue() => _isLightTheme ? light.textBlue : light.textBlue;

  /// Textfield
  static Color textFieldBG() => _isLightTheme ? light.textFieldBG : light.textFieldBG;
  static Color textFieldDisabledBG() => _isLightTheme ? light.textFieldDisabledBG : light.textFieldDisabledBG;
  static Color textFieldBorderColor() => _isLightTheme ? light.textFieldBorder : light.textFieldBorder;
  static Color textFieldFocusedBorderColor() => _isLightTheme ? light.textFieldFocusedBorder : light.textFieldFocusedBorder;
  static Color textFieldErrorColor() => _isLightTheme ? light.textFieldError : light.textFieldError;
  static Color textFieldIconColor() => _isLightTheme ? light.textFieldIcon : light.textFieldIcon;
  static Color textFieldIconFocusedColor() => _isLightTheme ? light.textFieldIconFocused : light.textFieldIconFocused;
  static Color textFieldIconDisableColor() => _isLightTheme ? light.textFieldIconDisable : light.textFieldIconDisable;
  static Color textFieldCursorColor() => _isLightTheme ? light.textFieldCursor : light.textFieldCursor;

  /// Textfield - Text
  static Color textFieldTextColor() => _isLightTheme ? light.textFieldText : light.textFieldText;
  static Color textFieldTextHintColor() => _isLightTheme ? light.textFieldTextHint : light.textFieldTextHint;

  /// Button
  static Color buttonColor() => _isLightTheme ? light.button : light.button;
  static Color buttonDisableColor() => _isLightTheme ? light.buttonDisable : light.buttonDisable;
  static Color buttonAttentionColor() => _isLightTheme ? light.buttonAttention : light.buttonAttention;
  static Color buttonSplashPrimaryColor() => _isLightTheme ? light.buttonSplashGrey : light.buttonSplashGrey;
  static Color buttonSplashSecondaryColor() => _isLightTheme ? light.buttonSplashBlue : light.buttonSplashBlue;

  /// Button - Text
  static Color buttonTextPrimaryColor() => _isLightTheme ? light.buttonTextWhite : light.buttonTextWhite;
  static Color buttonTextSecondaryColor() => _isLightTheme ? light.buttonTextBlack : light.buttonTextBlack;

  /// List builder
  static Color listTileBG() => _isLightTheme ? light.listTileBG : light.listTileBG;

  /// Popup menu
  static Color popupMenuBG() => _isLightTheme ? light.popupMenuBG : light.popupMenuBG;
  static Color popupMenuShadowColor() => _isLightTheme ? light.popupMenuShadow : light.popupMenuShadow;
  static Color popupMenuTextColor() => _isLightTheme ? light.popupMenuText : light.popupMenuText;
  static Color popupMenuImportantTextColor() => _isLightTheme ? light.popupMenuImportantText : light.popupMenuImportantText;
  static Color popupMenuIconColor(CustomPopupMenuType type) {
    switch (type) {
      case CustomPopupMenuType.appbar:
        return _isLightTheme ? light.iconWhite : light.iconWhite;

      case CustomPopupMenuType.card:
        return _isLightTheme ? light.iconBlack : light.iconBlack;
    }
  }

  /// Progress indicator
  static Color progressIndicatorBG() => _isLightTheme ? light.progressIndicatorBG : light.progressIndicatorBG;
  static Color progressIndicatorWebBG() => _isLightTheme ? light.progressIndicatorWebBG : light.progressIndicatorWebBG;
  static Color progressIndicatorColor() => _isLightTheme ? light.progressIndicator : light.progressIndicator;
  static Color progressIndicatorShadowColor() => _isLightTheme ? light.progressIndicatorShadow : light.progressIndicatorShadow;

  /// Gradients
  static List<Color> scaffoldGradientOpacity() => _isLightTheme ? light.scaffoldGradientOpacity : light.scaffoldGradientOpacity;

  /// Dash navigator
  static Color dashActiveColor({bool? isLight}) => isLight ?? _isLightTheme ? light.dashActive : light.dashActive;
  static Color dashDisableColor({bool? isLight}) => isLight ?? _isLightTheme ? light.dashDisable : light.dashDisable;

  /// Progress bar
  static Color progressBarActiveColor({bool? isLight}) => isLight ?? _isLightTheme ? light.progressBarActive : light.progressBarActive;
  static Color progressBarDisableColor({bool? isLight}) => isLight ?? _isLightTheme ? light.progressBarDisable : light.progressBarDisable;

  /// Additional
  static Color attentionColor() => _isLightTheme ? light.attention : light.attention;
}

class _LightColorTheme {
  /// Service
  final divider = const Color(0xFF000000).withOpacity(0.2);
  final overlay = const Color(0xFF000000).withOpacity(0.2);

  /// Background
  final scaffoldBG = const Color(0xFFF2F7F4);
  final dialogsBG = const Color(0xFFFFFFFF);

  /// Status bar
  final statusBarColor = const Color(0xFF415DE6);

  /// App bar
  final appBarBG = const Color(0xFF415DE6);
  final appBarShadow = const Color(0xFF114E70).withOpacity(0.03);
  final appBarText = const Color(0xFFFFFFFF);

  /// Navigation bar
  final navigationBarBG = const Color(0xFFFFFFFF);
  final navigationBarShadow = const Color(0xFF000000).withOpacity(0.05);
  final navigationBarActiveItem = const Color(0xFF5773FB);
  final navigationBarDisableItem = const Color(0xFFD0D7EA);

  /// Text
  final textBlack = const Color(0xFF000000);
  final textGrey = const Color(0xFF858585);
  final textWhite = const Color(0xFFFFFFFF);
  final textBlue = const Color(0xFF5773FB);

  /// Textfield
  final textFieldBG = const Color(0xFFFFFFFF);
  final textFieldDisabledBG = const Color(0xFFF5F5F5);
  final textFieldBorder = const Color(0xFFD6D6D6);
  final textFieldFocusedBorder = const Color(0xFF5773FB);
  final textFieldError = const Color(0xFFFF4444);
  final textFieldIcon = const Color(0xFFC2C2C2);
  final textFieldIconFocused = const Color(0xFF5773FB);
  final textFieldIconDisable = const Color(0xFFD6D6D6);
  final textFieldCursor = const Color(0xFF5773FB);

  /// Textfield - Text
  final textFieldText = const Color(0xFF000000);
  final textFieldTextHint = const Color(0xFF858585);

  /// Button
  final button = const Color(0xFF5773FB);
  final buttonDisable = const Color(0xFFD0D7EA);
  final buttonAttention = const Color(0xFFFF4444);
  final buttonSplashGrey = const Color(0xFFFFFFFF).withOpacity(0.1);
  final buttonSplashBlue = const Color(0xFF5773FB).withOpacity(0.05);

  /// Button - Text
  final buttonTextWhite = const Color(0xFFFFFFFF);
  final buttonTextBlack = const Color(0xFF000000);

  /// List builder
  final listTileBG = const Color(0xFFFFFFFF);

  /// Icon
  final iconWhite = const Color(0xFFFFFFFF);
  final iconDarkGrey = const Color(0xFF858585);
  final iconBlack = const Color(0xFF1A1A1A);

  /// Popup menu
  final popupMenuBG = const Color(0xFF333333);
  final popupMenuShadow = const Color(0xFF144662).withOpacity(0.2);
  final popupMenuText = const Color(0xFFFFFFFF);
  final popupMenuImportantText = const Color(0xFFEB5757);

  /// Progress indicator
  final progressIndicatorBG = const Color(0xFFFFFFFF);
  final progressIndicatorWebBG = const Color(0xFFF1F5FF);
  final progressIndicator = const Color(0xFF5773FB);
  final progressIndicatorShadow = const Color(0xFF186B99).withOpacity(0.05);

  /// Contact
  final contactCardWebBG = const Color(0xFFF1F5FF);
  final contactIconGradient = <Color>[
    const Color(0xFF5773FB),
    const Color(0xFF415DE6),
  ];

  /// Gradients
  final scaffoldGradientOpacity = <Color>[
    const Color(0xFFF2F7F4).withOpacity(0.0),
    const Color(0xFFF2F7F4),
  ];

  /// Dash navigator
  final dashActive = const Color(0xFF06913E);
  final dashDisable = const Color(0xFFCDE7D9);

  /// Progress bar
  final progressBarActive = const Color(0xFF06913E);
  final progressBarDisable = const Color(0xFFCDE7D9);

  /// Additional
  final attention = const Color(0xFFFF003D);
}

class _DarkColorTheme {

}