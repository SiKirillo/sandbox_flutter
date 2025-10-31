part of '../_common/common.dart';

class ThemeConstants {
  static ThemeData get light => ThemeData.lerp(ThemeData.light(), _lightTheme, 1.0).copyWith(
    /// You need to disable the ripple effect during the transition animation
    /// from one screen to another (Material3 bug)
    pageTransitionsTheme: PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: ZoomPageTransitionsBuilder(
          allowEnterRouteSnapshotting: false,
        ),
      },
    ),
  );

  static ThemeData get dark => ThemeData.lerp(ThemeData.dark(), _darkTheme, 1.0).copyWith(
    pageTransitionsTheme: PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: ZoomPageTransitionsBuilder(
          allowEnterRouteSnapshotting: false,
        ),
      },
    ),
  );

  static final _lightTheme = ThemeData(
    fontFamily: kIsWeb || Platform.isAndroid ? 'Montserrat' : 'OpenSans',
    brightness: Brightness.light,
    scaffoldBackgroundColor: ColorConstants.light.scaffoldBG,
    canvasColor: ColorConstants.light.scaffoldBG,
    appBarTheme: AppBarTheme(
      backgroundColor: ColorConstants.light.appBarBG,
      shadowColor: ColorConstants.light.appBarShadow,
      surfaceTintColor: ColorConstants.transparent,
      elevation: 0.0,
      titleTextStyle: TextStyle(
        fontFamily: kIsWeb || Platform.isAndroid ? 'Montserrat' : 'OpenSans',
        fontSize: 14.0,
        fontWeight: FontWeight.w700,
        height: 17.0 / 14.0,
        color: ColorConstants.light.appBarText,
        letterSpacing: 0.0,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: ColorConstants.light.bottomSheetBG,
      surfaceTintColor: ColorConstants.transparent,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: ColorConstants.light.dialogBG,
      surfaceTintColor: ColorConstants.transparent,
      titleTextStyle: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w700,
        height: 20.0 / 16.0,
        color: ColorConstants.light.textBlack,
        letterSpacing: 0.0,
      ),
      contentTextStyle: TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w500,
        height: 16.0 / 12.0,
        color: ColorConstants.light.textBlack.withValues(alpha: 0.7),
        letterSpacing: 0.0,
      ),
    ),
    textTheme: _getTextThemeByType(ThemeMode.light),
    inputDecorationTheme: _getInputFieldThemeByType(ThemeMode.light),
    dividerTheme: DividerThemeData(
      color: ColorConstants.light.divider,
    ),
    listTileTheme: ListTileThemeData(
      tileColor: ColorConstants.transparent,
    ),
  );

  static final _darkTheme = _lightTheme;

  static TextTheme _getTextThemeByType(ThemeMode mode) {
    return TextTheme(
      /// Headline labels
      headlineLarge: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w700,
        height: 29.0 / 24.0,
        color: mode == ThemeMode.light
            ? ColorConstants.light.textBlack
            : ColorConstants.light.textBlack,
        letterSpacing: 0.0,
      ),
      headlineMedium: TextStyle(
        fontSize: 21.0,
        fontWeight: FontWeight.w700,
        height: 26.0 / 21.0,
        color: mode == ThemeMode.light
            ? ColorConstants.light.textBlack
            : ColorConstants.light.textBlack,
        letterSpacing: 0.0,
      ),
      headlineSmall: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w700,
        height: 22.0 / 18.0,
        color: mode == ThemeMode.light
            ? ColorConstants.light.textBlack
            : ColorConstants.light.textBlack,
        letterSpacing: 0.0,
      ),

      /// Smaller headline labels
      labelMedium: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w700,
        height: 20.0 / 16.0,
        color: mode == ThemeMode.light
            ? ColorConstants.light.textBlack
            : ColorConstants.light.textBlack,
        letterSpacing: 0.0,
      ),
      labelSmall: TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w700,
        height: 15.0 / 12.0,
        color: mode == ThemeMode.light
            ? ColorConstants.light.textBlack
            : ColorConstants.light.textBlack,
        letterSpacing: 0.0,
      ),

      /// Default texts
      bodyLarge: TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.w600,
        height: 18.0 / 15.0,
        color: mode == ThemeMode.light
            ? ColorConstants.light.textBlack
            : ColorConstants.light.textBlack,
        letterSpacing: 0.0,
      ),
      bodyMedium: TextStyle(
        fontSize: 13.0,
        fontWeight: FontWeight.w500,
        height: 18.0 / 13.0,
        color: mode == ThemeMode.light
            ? ColorConstants.light.textBlack
            : ColorConstants.light.textBlack,
        letterSpacing: 0.0,
      ),
      bodySmall: TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w500,
        height: 16.0 / 12.0,
        color: mode == ThemeMode.light
            ? ColorConstants.light.textBlack
            : ColorConstants.light.textBlack,
        letterSpacing: 0.0,
      ),

      /// Smaller default texts
      titleSmall: TextStyle(
        fontSize: 11.0,
        fontWeight: FontWeight.w400,
        height: 13.0 / 11.0,
        color: mode == ThemeMode.light
            ? ColorConstants.light.textBlack
            : ColorConstants.light.textBlack,
        letterSpacing: 0.0,
      ),

      /// Service (button) texts
      displayMedium: TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.w500,
        height: 18.0 / 15.0,
        color: mode == ThemeMode.light
            ? ColorConstants.light.textWhite
            : ColorConstants.light.textWhite,
        letterSpacing: 0.0,
      ),
      displaySmall: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        height: 17.0 / 14.0,
        color: mode == ThemeMode.light
            ? ColorConstants.light.textWhite
            : ColorConstants.light.textWhite,
        letterSpacing: 0.0,
      ),
    );
  }

  static InputDecorationTheme _getInputFieldThemeByType(ThemeMode mode) {
    return InputDecorationTheme(
      filled: true,
      errorMaxLines: 3,
      helperMaxLines: 3,
      contentPadding: SizeConstants.defaultTextInputPadding,
      iconColor: mode == ThemeMode.light
          ? ColorConstants.light.textFieldIcon
          : ColorConstants.light.textFieldIcon,
      fillColor: mode == ThemeMode.light
          ? ColorConstants.light.textFieldBG
          : ColorConstants.light.textFieldBG,
      labelStyle: TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.w400,
        height: 18.0 / 15.0,
        color: mode == ThemeMode.light
            ? ColorConstants.light.textFieldLabel
            : ColorConstants.light.textFieldLabel,
        letterSpacing: 0.0,
      ),
      hintStyle: TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.w400,
        height: 18.0 / 15.0,
        color: mode == ThemeMode.light
            ? ColorConstants.light.textFieldTextHint
            : ColorConstants.light.textFieldTextHint,
        letterSpacing: 0.0,
      ),
      helperStyle: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        height: 19.0 / 14.0,
        color: mode == ThemeMode.light
            ? ColorConstants.light.textFieldTextHelper
            : ColorConstants.light.textFieldTextHelper,
        letterSpacing: 0.0,
      ),
      errorStyle: TextStyle(
        fontSize: 11.0,
        fontWeight: FontWeight.w500,
        height: 14.0 / 11.0,
        color: mode == ThemeMode.light
            ? ColorConstants.light.textFieldTextError
            : ColorConstants.light.textFieldTextError,
        letterSpacing: 0.0,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: mode == ThemeMode.light
              ? ColorConstants.light.textFieldBorder
              : ColorConstants.light.textFieldBorder,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: mode == ThemeMode.light
              ? ColorConstants.light.textFieldBorderFocused
              : ColorConstants.light.textFieldBorderFocused,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: mode == ThemeMode.light
              ? ColorConstants.light.textFieldBorder
              : ColorConstants.light.textFieldBorder,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: mode == ThemeMode.light
              ? ColorConstants.light.textFieldBorderError
              : ColorConstants.light.textFieldBorderError,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: mode == ThemeMode.light
              ? ColorConstants.light.textFieldBorderError
              : ColorConstants.light.textFieldBorderError,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: mode == ThemeMode.light
              ? ColorConstants.light.textFieldBorder
              : ColorConstants.light.textFieldBorder,
        ),
      ),
    );
  }
}
