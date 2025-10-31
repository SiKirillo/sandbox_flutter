part of '../_common/common.dart';

class ColorConstants {
  static final light = _LightColorTheme();
  static final dark = _DarkColorTheme();
  static bool get _isLightTheme => locator<ThemeProvider>().isLight;

  /// Common
  /// Service
  static const transparent = Color(0x00000000);
  static Color divider() => _isLightTheme ? light.divider : light.divider;

  /// Overlay
  static Color overlay() => _isLightTheme ? light.overlay : light.overlay;
  static Color overlayBG() => _isLightTheme ? light.overlayBG : light.overlayBG;
  static Color overlayBorder() => _isLightTheme ? light.overlayBorder : light.overlayBorder;

  /// Logger
  static Color loggerButton() => _isLightTheme ? light.loggerButton : light.loggerButton;
  static Color loggerButtonContent() => _isLightTheme ? light.loggerButtonContent : light.loggerButtonContent;
  static Color loggerButtonShadow() => _isLightTheme ? light.loggerButtonShadow : light.loggerButtonShadow;

  /// Background
  static Color scaffoldBG() => _isLightTheme ? light.scaffoldBG : light.scaffoldBG;
  static Color splashBG() => _isLightTheme ? light.splashBG : light.splashBG;

  /// Dialog
  static Color dialog() => _isLightTheme ? light.dialog : light.dialog;
  static Color dialogBG() => _isLightTheme ? light.dialogBG : light.dialogBG;
  static Color dialogShadow() => _isLightTheme ? light.dialogShadow : light.dialogShadow;
  static Color dialogAction() => _isLightTheme ? light.dialogAction : light.dialogAction;
  static Color dialogInfo() => _isLightTheme ? light.dialogInfo : light.dialogInfo;
  static Color dialogCancel() => _isLightTheme ? light.dialogCancel : light.dialogCancel;

  /// Bottom sheet
  static Color bottomSheetBG() => _isLightTheme ? light.bottomSheetBG : light.bottomSheetBG;
  static Color bottomSheetScrollTab() => _isLightTheme ? light.bottomSheetScrollTab : light.bottomSheetScrollTab;

  /// App bar
  static Color appBarBG() => _isLightTheme ? light.appBarBG : light.appBarBG;
  static Color appBarDivider() => _isLightTheme ? light.appBarDivider : light.appBarDivider;

  /// Navigation bar
  static Color navigationBarBG(CustomNavigationBarType type) {
    return switch (type) {
      CustomNavigationBarType.white => _isLightTheme ? light.navigationBarBGWhite : light.navigationBarBGWhite,
      CustomNavigationBarType.blue => _isLightTheme ? light.navigationBarBGBlue : light.navigationBarBGBlue,
    };
  }
  static Color navigationBarShadow() => _isLightTheme ? light.navigationBarShadow : light.navigationBarShadow;
  static Color navigationBarActive(CustomNavigationBarType type) {
    return switch (type) {
      CustomNavigationBarType.white => _isLightTheme ? light.navigationBarActiveBlueItem : light.navigationBarActiveBlueItem,
      CustomNavigationBarType.blue => _isLightTheme ? light.navigationBarActiveWhiteItem : light.navigationBarActiveWhiteItem,
    };
  }
  static Color navigationBarDisable(CustomNavigationBarType type) {
    return switch (type) {
      CustomNavigationBarType.white => _isLightTheme ? light.navigationBarDisableBlueItem : light.navigationBarDisableBlueItem,
      CustomNavigationBarType.blue => _isLightTheme ? light.navigationBarDisableWhiteItem : light.navigationBarDisableWhiteItem,
    };
  }

  /// Text
  static Color textBlack() => _isLightTheme ? light.textBlack : light.textBlack;
  static Color textWhite() => _isLightTheme ? light.textWhite : light.textWhite;
  static Color textGrey() => _isLightTheme ? light.textGrey : light.textGrey;

  /// Textfield
  static Color textFieldBG() => _isLightTheme ? light.textFieldBG : light.textFieldBG;
  static Color textFieldSearchBG() => _isLightTheme ? light.textFieldSearchBG : light.textFieldSearchBG;
  static Color textFieldBorder() => _isLightTheme ? light.textFieldBorder : light.textFieldBorder;
  static Color textFieldBorderFocused() => _isLightTheme ? light.textFieldBorderFocused : light.textFieldBorderFocused;
  static Color textFieldBorderError() => _isLightTheme ? light.textFieldBorderError : light.textFieldBorderError;

  /// Textfield - Icon
  static Color textFieldIcon() => _isLightTheme ? light.textFieldIcon : light.textFieldIcon;
  static Color textFieldIconActive() => _isLightTheme ? light.textFieldIconActive : light.textFieldIconActive;
  static Color textFieldIconDisable() => _isLightTheme ? light.textFieldIconDisable : light.textFieldIconDisable;
  static Color textFieldIconError() => _isLightTheme ? light.textFieldIconError : light.textFieldIconError;

  /// Textfield - Text
  static Color textFieldText() => _isLightTheme ? light.textFieldText : light.textFieldText;
  static Color textFieldTextDisable() => _isLightTheme ? light.textFieldTextDisable : light.textFieldTextDisable;
  static Color textFieldLabel() => _isLightTheme ? light.textFieldLabel : light.textFieldLabel;
  static Color textFieldTextHint() => _isLightTheme ? light.textFieldTextHint : light.textFieldTextHint;
  static Color textFieldTextHelper() => _isLightTheme ? light.textFieldTextHelper : light.textFieldTextHelper;

  /// Textfield - Error
  static Color textFieldTextErrorBG() => _isLightTheme ? light.textFieldTextErrorBG : light.textFieldTextErrorBG;
  static Color textFieldTextError() => _isLightTheme ? light.textFieldTextError : light.textFieldTextError;

  /// Button
  static Color button(CustomButtonType type) {
    return switch (type) {
      CustomButtonType.blue => _isLightTheme ? light.buttonBlue : light.buttonBlue,
      CustomButtonType.white => _isLightTheme ? light.buttonWhite : light.buttonWhite,
      CustomButtonType.appbar => _isLightTheme ? light.buttonAppBar : light.buttonAppBar,
    };
  }
  static Color buttonDisable() => _isLightTheme ? light.buttonDisable : light.buttonDisable;
  static Color buttonSplash(CustomButtonType type) {
    return switch (type) {
      CustomButtonType.blue => _isLightTheme ? light.buttonSplashWhite : light.buttonSplashWhite,
      CustomButtonType.white => _isLightTheme ? light.buttonSplashBlue : light.buttonSplashBlue,
      CustomButtonType.appbar => _isLightTheme ? light.buttonSplashAppBar : light.buttonSplashAppBar,
    };
  }
  static Color buttonContent(CustomButtonType type) {
    return switch (type) {
      CustomButtonType.blue => _isLightTheme ? light.buttonContentWhite : light.buttonContentWhite,
      CustomButtonType.white => _isLightTheme ? light.buttonContentBlue : light.buttonContentBlue,
      CustomButtonType.appbar => _isLightTheme ? light.buttonContentWhite : light.buttonContentWhite,
    };
  }

  static Color buttonText() => _isLightTheme ? light.buttonText : light.buttonText;
  static Color buttonTextDisable() => _isLightTheme ? light.buttonTextDisable : light.buttonTextDisable;
  static Color buttonTextSplash() => _isLightTheme ? light.buttonTextSplash : light.buttonTextSplash;

  static Color buttonOutline() => _isLightTheme ? light.buttonOutline : light.buttonOutline;
  static Color buttonOutlineDisable() => _isLightTheme ? light.buttonOutlineDisable : light.buttonOutlineDisable;
  static Color buttonOutlineSplash() => _isLightTheme ? light.buttonOutlineSplash : light.buttonOutlineSplash;

  static Color buttonSmall(CustomSmallButtonType type) {
    return switch (type) {
      CustomSmallButtonType.transparent => _isLightTheme ? light.buttonSmallTransparent : light.buttonSmallTransparent,
      CustomSmallButtonType.blue => _isLightTheme ? light.buttonSmallBlue : light.buttonSmallBlue,
      CustomSmallButtonType.attention => _isLightTheme ? light.buttonSmallAttention : light.buttonSmallAttention,
    };
  }
  static Color buttonSmallDisable() => _isLightTheme ? light.buttonOutlineDisable : light.buttonOutlineDisable;
  static Color buttonSmallSplash(CustomSmallButtonType type) {
    return switch (type) {
      CustomSmallButtonType.transparent => _isLightTheme ? light.buttonSmallSplashTransparent : light.buttonSmallSplashTransparent,
      CustomSmallButtonType.blue => _isLightTheme ? light.buttonSmallSplashBlue : light.buttonSmallSplashBlue,
      CustomSmallButtonType.attention => _isLightTheme ? light.buttonSmallSplashAttention : light.buttonSmallSplashAttention,
    };
  }
  static Color buttonSmallContent(CustomSmallButtonType type) {
    return switch (type) {
      CustomSmallButtonType.transparent => _isLightTheme ? light.buttonContentBlue : light.buttonContentBlue,
      CustomSmallButtonType.blue => _isLightTheme ? light.buttonContentWhite : light.buttonContentWhite,
      CustomSmallButtonType.attention => _isLightTheme ? light.buttonContentWhite : light.buttonContentWhite,
    };
  }

  static Color buttonHyperlink() => _isLightTheme ? light.buttonHyperlink : light.buttonHyperlink;

  /// Button - Content
  static Color buttonContentWhite() => _isLightTheme ? light.buttonContentWhite : light.buttonContentWhite;
  static Color buttonContentBlue() => _isLightTheme ? light.buttonContentBlue : light.buttonContentBlue;
  static Color buttonContentRed() => _isLightTheme ? light.buttonContentRed : light.buttonContentRed;
  static Color buttonContentDisable() => _isLightTheme ? light.buttonContentDisable : light.buttonContentDisable;

  /// Switch
  static Color switchActiveBG() => _isLightTheme ? light.switchActiveBG : light.switchActiveBG;
  static Color switchInactiveBG() => _isLightTheme ? light.switchInactiveBG : light.switchInactiveBG;
  static Color switchActiveThumb() => _isLightTheme ? light.switchActiveThumb : light.switchActiveThumb;
  static Color switchInactiveThumb() => _isLightTheme ? light.switchInactiveThumb : light.switchInactiveThumb;

  /// Popup menu
  static Color popupMenuBG() => _isLightTheme ? light.popupMenuBG : light.popupMenuBG;
  static Color popupMenuShadow() => _isLightTheme ? light.popupMenuShadow : light.popupMenuShadow;
  static Color popupMenuText() => _isLightTheme ? light.popupMenuText : light.popupMenuText;
  static Color popupMenuImportantText() => _isLightTheme ? light.popupMenuImportantText : light.popupMenuImportantText;
  static Color popupMenuIcon(CustomPopupMenuType type) {
    return switch (type) {
      CustomPopupMenuType.appbar => _isLightTheme ? light.iconWhite : light.iconWhite,
      CustomPopupMenuType.card => _isLightTheme ? light.iconBlack : light.iconBlack,
    };
  }

  /// Dropdown
  static Color dropdownBG() => _isLightTheme ? light.dropdownBG : light.dropdownBG;
  static Color dropdownItemBG() => _isLightTheme ? light.dropdownItemBG : light.dropdownItemBG;
  static Color dropdownBorder() => _isLightTheme ? light.dropdownBorder : light.dropdownBorder;
  static Color dropdownBorderFocused() => _isLightTheme ? light.dropdownBorderFocused : light.dropdownBorderFocused;
  static Color dropdownBorderError() => _isLightTheme ? light.dropdownBorderError : light.dropdownBorderError;
  static Color dropdownIconActive() => _isLightTheme ? light.dropdownIconActive : light.dropdownIconActive;
  static Color dropdownIconDisable() => _isLightTheme ? light.dropdownIconDisable : light.dropdownIconDisable;

  /// Dropdown - Text
  static Color dropdownText() => _isLightTheme ? light.dropdownText : light.dropdownText;
  static Color dropdownTextDisable() => _isLightTheme ? light.dropdownTextDisable : light.dropdownTextDisable;
  static Color dropdownTextHint() => _isLightTheme ? light.dropdownTextHint : light.dropdownTextHint;

  /// Progress indicator
  static Color progressIndicatorBG() => _isLightTheme ? light.progressIndicatorBG : light.progressIndicatorBG;
  static Color progressIndicator() => _isLightTheme ? light.progressIndicator : light.progressIndicator;
  static Color progressIndicatorShadow() => _isLightTheme ? light.progressIndicatorShadow : light.progressIndicatorShadow;

  /// Appbar indicator
  static Color appbarIndicatorActive() => _isLightTheme ? light.appbarIndicatorActive : light.appbarIndicatorActive;
  static Color appbarIndicatorDisable() => _isLightTheme ? light.appbarIndicatorDisable : light.appbarIndicatorDisable;

  /// Page indicator
  static Color pageIndicatorActive() => _isLightTheme ? light.pageIndicatorActive : light.pageIndicatorActive;
  static Color pageIndicatorDisable() => _isLightTheme ? light.pageIndicatorDisable : light.pageIndicatorDisable;

  /// Checkbox
  static Color checkboxCheck() => _isLightTheme ? light.checkboxCheck : light.checkboxCheck;
  static Color checkboxActive() => _isLightTheme ? light.checkboxActive : light.checkboxActive;
  static Color checkboxBorder() => _isLightTheme ? light.checkboxBorder : light.checkboxBorder;

  /// Slider
  static Color sliderTrackActive() => _isLightTheme ? light.sliderTrackActive : light.sliderTrackActive;
  static Color sliderTrackDisable() => _isLightTheme ? light.sliderTrackDisable : light.sliderTrackDisable;
  static Color sliderThumb() => _isLightTheme ? light.sliderThumb : light.sliderThumb;
  static Color sliderOverlay() => _isLightTheme ? light.sliderOverlay : light.sliderOverlay;

  /// Tab button
  static Color tabButtonActive() => _isLightTheme ? light.tabButtonActive : light.tabButtonActive;
  static Color tabButtonDisable() => _isLightTheme ? light.tabButtonDisable : light.tabButtonDisable;
  static Color tabButtonLengthActive() => _isLightTheme ? light.tabButtonLengthActive : light.tabButtonLengthActive;
  static Color tabButtonLengthDisable() => _isLightTheme ? light.tabButtonLengthDisable : light.tabButtonLengthDisable;

  /// Card
  static Color cardBG() => _isLightTheme ? light.cardBG : light.cardBG;
  static Color cardBorder() => _isLightTheme ? light.cardBorder : light.cardBorder;

  /// In app toast
  static Color inAppToastBG() => _isLightTheme ? light.inAppToastBG : light.inAppToastBG;
  static Color inAppToastText() => _isLightTheme ? light.inAppToastText : light.inAppToastText;

  /// In app notification
  static Color inAppNotificationBG() => _isLightTheme ? light.inAppNotificationBG : light.inAppNotificationBG;
  static Color inAppNotificationText() => _isLightTheme ? light.inAppNotificationText : light.inAppNotificationText;

  /// Specific
  /// Camera
  static Color cameraBG() => _isLightTheme ? light.cameraBG : light.cameraBG;
  static Color cameraPreviewBG() => _isLightTheme ? light.cameraPreviewBG : light.cameraPreviewBG;
  static Color cameraOverlayBG() => _isLightTheme ? light.cameraOverlayBG : light.cameraOverlayBG;

  static Color cameraButtonWhite() => _isLightTheme ? light.cameraButtonWhite : light.cameraButtonWhite;
  static Color cameraButtonBlack() => _isLightTheme ? light.cameraButtonBlack : light.cameraButtonBlack;

  static Color cameraFocusArea() => _isLightTheme ? light.cameraFocusArea : light.cameraFocusArea;
  static Color cameraScannerArea() => _isLightTheme ? light.cameraScannerArea : light.cameraScannerArea;
  static Color cameraScannerSuccess() => _isLightTheme ? light.cameraScannerSuccess : light.cameraScannerSuccess;

  static Color cameraPictureCardBG() => _isLightTheme ? light.cameraPictureCardBG : light.cameraPictureCardBG;
  static Color cameraPictureCardBorder() => _isLightTheme ? light.cameraPictureCardBorder : light.cameraPictureCardBorder;
}

class _LightColorTheme {
  /// Common
  /// Service
  final divider = Color(0xFF000000).withValues(alpha: 0.05);

  /// Overlay
  final overlay = Color(0xFFFFFFFF).withValues(alpha: 0.4);
  final overlayBG = Color(0xFFFFFFFF);
  final overlayBorder = Color(0xFFE0E0E0);

  /// Logger
  final loggerButton = Color(0xA0B71C1C);
  final loggerButtonContent = Color(0xFFFFFFFF);
  final loggerButtonShadow = Color(0x7F000000);

  /// Background
  final scaffoldBG = Color(0xFFF9F9F9);
  final splashBG = Color(0xFF0C3480);

  /// Dialog
  final dialog = Color(0x80000000);
  final dialogBG = Color(0xFFFFFFFF);
  final dialogShadow = Color(0xFF000000).withValues(alpha: 0.2);
  final dialogAction = Color(0xFFF13545);
  final dialogInfo = Color(0xFF00B0EB);
  final dialogCancel = Color(0xFF202020);

  /// Bottom sheet
  final bottomSheetBG = Color(0xFFFCFCFC);
  final bottomSheetScrollTab = Color(0xFFD9D9D9);

  /// App bar
  final appBarBG = Color(0xFFFFFFFF);
  final appBarShadow = Color(0xFFFFFFFF).withValues(alpha: 0.2);
  final appBarDivider = Color(0xFF000000).withValues(alpha: 0.1);
  final appBarText = Color(0xFF000000);

  /// Navigation bar
  final navigationBarBGWhite = Color(0xFFFFFFFF);
  final navigationBarBGBlue = Color(0xFF1245A5);
  final navigationBarShadow = Color(0xFF4D4D4D).withValues(alpha: 0.5);

  final navigationBarActiveBlueItem = Color(0xFF1245A5);
  final navigationBarDisableBlueItem = Color(0xFFCACACA);
  final navigationBarActiveWhiteItem = Color(0xFFFFFFFF);
  final navigationBarDisableWhiteItem = Color(0xFFFFFFFF).withValues(alpha: 0.5);

  /// Text
  final textBlack = Color(0xFF000000);
  final textWhite = Color(0xFFFFFFFF);
  final textGrey = Color(0xFFFCFCFC);

  /// Textfield
  final textFieldBG = Color(0xFFF9F9F9);
  final textFieldSearchBG = Color(0xFFF7F7F7);
  final textFieldBorder = Color(0xFFE0E0E0);
  final textFieldBorderFocused = Color(0xFF00B0EB);
  final textFieldBorderError = Color(0xFFF13545);

  /// Textfield - Icon
  final textFieldIcon = Color(0xFF4D4D4D).withValues(alpha: 0.5);
  final textFieldIconActive = Color(0xFF4D4D4D);
  final textFieldIconDisable = Color(0xFF4D4D4D).withValues(alpha: 0.4);
  final textFieldIconError = Color(0xFFF13545).withValues(alpha: 0.86);

  /// Textfield - Text
  final textFieldText = Color(0xFF000000);
  final textFieldTextDisable = Color(0xFF4D4D4D).withValues(alpha: 0.4);
  final textFieldLabel = Color(0xFF4D4D4D);
  final textFieldTextHint = Color(0xFF4D4D4D);
  final textFieldTextHelper = Color(0xFF4D4D4D).withValues(alpha: 0.86);

  /// Textfield - Error
  final textFieldTextErrorBG = Color(0xFFF13545).withValues(alpha: 0.08);
  final textFieldTextError = Color(0xFFF13545);

  /// Button
  final buttonBlue = Color(0xFF0C3480);
  final buttonWhite = Color(0xFFF3F5FB);
  final buttonAppBar = Color(0xFF2853A3);
  final buttonDisable = Color(0xFFF1F1F1);

  final buttonSplashBlue = Color(0xFF5673AA).withValues(alpha: 0.15);
  final buttonSplashWhite = Color(0xFFFFFFFF).withValues(alpha: 0.15);
  final buttonSplashAppBar = Color(0xFF2853A3).withValues(alpha: 0.15);

  final buttonText = Color(0x00000000);
  final buttonTextDisable = Color(0xFFF1F1F1);
  final buttonTextSplash = Color(0xFF5673AA);

  final buttonOutline = Color(0xFF0C3480);
  final buttonOutlineDisable = Color(0xFFF1F1F1);
  final buttonOutlineSplash = Color(0xFF5673AA);

  final buttonSmallTransparent = Color(0xFFFFFFFF);
  final buttonSmallBlue = Color(0xFF2853A3);
  final buttonSmallAttention = Color(0xFFF13545);
  final buttonSmallDisable = Color(0xFFF1F1F1);

  final buttonSmallSplashTransparent = Color(0xFF5673AA).withValues(alpha: 0.15);
  final buttonSmallSplashBlue = Color(0xFFFFFFFF).withValues(alpha: 0.15);
  final buttonSmallSplashAttention = Color(0xFFFFFFFF).withValues(alpha: 0.15);

  final buttonHyperlink = Color(0xFF0C3480);

  /// Button - Content
  final buttonContentWhite = Color(0xFFFFFFFF);
  final buttonContentBlue = Color(0xFF0C3480);
  final buttonContentRed = Color(0xFFF13545);
  final buttonContentDisable = Color(0xFF4D4D4D).withValues(alpha: 0.3);

  /// Switch
  final switchActiveBG = Color(0xFF4CAF50);
  final switchInactiveBG = Color(0xFFD1D5DB);
  final switchActiveThumb = Color(0xFFFFFFFF);
  final switchInactiveThumb = Color(0xFFFFFFFF);

  /// Popup menu
  final popupMenuBG = Color(0xFF333333);
  final popupMenuShadow = Color(0xFF144662).withValues(alpha: 0.2);
  final popupMenuText = Color(0xFFFFFFFF);
  final popupMenuImportantText = Color(0xFFF13545);

  /// Icon
  final iconWhite = Color(0xFFFFFFFF);
  final iconGrey = Color(0xFF858585);
  final iconBlack = Color(0xFF1A1A1A);

  /// Dropdown
  final dropdownBG = Color(0xFFF9F9F9);
  final dropdownItemBG = Color(0xFFFFFFFF);
  final dropdownBorder = Color(0xFFE0E0E0);
  final dropdownBorderFocused = Color(0xFF00B0EB);
  final dropdownBorderError = Color(0xFFF13545);
  final dropdownIconActive = Color(0xFF4D4D4D).withValues(alpha: 0.86);
  final dropdownIconDisable = Color(0xFF4D4D4D).withValues(alpha: 0.4);

  /// Dropdown - Text
  final dropdownText = Color(0xFF4D4D4D);
  final dropdownTextDisable = Color(0xFF4D4D4D).withValues(alpha: 0.4);
  final dropdownTextHint = Color(0xFF4D4D4D).withValues(alpha: 0.86);

  /// Progress indicator
  final progressIndicatorBG = Color(0xFFFFFFFF);
  final progressIndicator = Color(0xFFAFCA0A);
  final progressIndicatorShadow = Color(0xFFAFCA0A).withValues(alpha: 0.05);

  /// Appbar indicator
  final appbarIndicatorActive = Color(0xFFAFCA0A);
  final appbarIndicatorDisable = Color(0xFFF9F9F9).withValues(alpha: 0.1);

  /// Page indicator
  final pageIndicatorActive = Color(0xFFFFFFFF);
  final pageIndicatorDisable = Color(0xFF5673AA);

  /// Checkbox
  final checkboxCheck = Color(0xFFFFFFFF);
  final checkboxActive = Color(0xFF0C3480);
  final checkboxBorder = Color(0xFFB8B8B8);

  /// Slider
  final sliderTrackActive = Color(0xFFFFFFFF);
  final sliderTrackDisable = Color(0xFF3A60A7);
  final sliderThumb = Color(0xFFFFFFFF);
  final sliderOverlay = Color(0xFFFFFFFF).withValues(alpha: 0.2);

  /// Tab button
  final tabButtonActive = Color(0xFF4FAF47);
  final tabButtonDisable = Color(0xFFF1F1F1);
  final tabButtonLengthActive = Color(0xFFFFFFFF).withValues(alpha: 0.2);
  final tabButtonLengthDisable = Color(0xFFFFFFFF);

  /// Card
  final cardBG = Color(0xFFFFFFFF);
  final cardBorder = Color(0xFFD1D5DB).withValues(alpha: 0.3);

  /// In app toast
  final inAppToastBG = Color(0xFFF13545).withValues(alpha: 0.08);
  final inAppToastText = Color(0xFFF13545);

  /// In app notification
  final inAppNotificationBG = Color(0xFF000000).withValues(alpha: 0.8);
  final inAppNotificationText = Color(0xFFFFFFFF);

  /// Specific
  /// Camera
  final cameraBG = Color(0xFF000000);
  final cameraPreviewBG = Color(0xFF000000).withValues(alpha: 0.5);
  final cameraOverlayBG = Color(0xFF000000).withValues(alpha: 0.5);

  final cameraButtonWhite = Color(0xFFFFFFFF);
  final cameraButtonBlack = Color(0xFF000000);

  final cameraFocusArea = Color(0xFFEF7C00);
  final cameraScannerArea = Color(0xFFFFFFFF);
  final cameraScannerSuccess = Color(0xFFAFCA0A);

  final cameraPictureCardBG = Color(0xFF0D3787);
  final cameraPictureCardBorder = Color(0xFFFFFFFF).withValues(alpha: 0.5);
}

class _DarkColorTheme {

}