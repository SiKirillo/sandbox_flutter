part of '../common/common.dart';

class ThemeConstants {
  static ThemeData get light => ThemeData.lerp(ThemeData.light(), _lightTheme, 1.0).copyWith(
    /// You need to disable the ripple effect during the transition animation
    /// from one screen to another (Material3 bug)
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: ZoomPageTransitionsBuilder(
          allowEnterRouteSnapshotting: false,
        ),
      },
    ),
  );

  static ThemeData get dark => ThemeData.lerp(ThemeData.dark(), _darkTheme, 1.0).copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: ZoomPageTransitionsBuilder(
          allowEnterRouteSnapshotting: false,
        ),
      },
    ),
  );

  static final _lightTheme = ThemeData(
    fontFamily: kIsWeb || Platform.isAndroid ? 'Roboto' : 'OpenSans',
    brightness: Brightness.light,
    scaffoldBackgroundColor: ColorConstants.light.scaffoldBG,
    canvasColor: ColorConstants.light.scaffoldBG,
    appBarTheme: AppBarTheme(
      backgroundColor: ColorConstants.light.appBarBG,
      shadowColor: ColorConstants.light.appBarShadow,
      surfaceTintColor: ColorConstants.transparent,
      elevation: 0.0,
      titleTextStyle: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
        height: 21.0 / 18.0,
        color: ColorConstants.light.appBarText,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: ColorConstants.light.navigationBarBG,
      shadowColor: ColorConstants.light.navigationBarShadow,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: ColorConstants.light.dialogsBG,
      surfaceTintColor: ColorConstants.transparent,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: ColorConstants.light.dialogsBG,
      surfaceTintColor: ColorConstants.transparent,
      titleTextStyle: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w400,
        height: 32.0 / 24.0,
        color: ColorConstants.light.textBlack,
      ),
    ),
    textTheme: _getTextThemeByType(ThemeMode.light),
    inputDecorationTheme: _getInputFieldThemeByType(ThemeMode.light),
    iconTheme: IconThemeData(
      color: ColorConstants.light.textFieldIcon,
    ),
    dividerTheme: DividerThemeData(
      color: ColorConstants.light.divider,
    ),
    listTileTheme: ListTileThemeData(
      tileColor: ColorConstants.light.listTileBG,
    ),
  );

  static final _darkTheme = _lightTheme;

  static TextTheme _getTextThemeByType(ThemeMode mode) {
    return TextTheme(
      /// Only for headline labels
      headlineMedium: TextStyle(
        fontSize: 21.0,
        fontWeight: FontWeight.w700,
        height: 25.0 / 21.0,
        color: mode == ThemeMode.light
            ? ColorConstants.light.textBlack
            : ColorConstants.light.textBlack,
      ),

      /// Default texts
      bodyMedium: TextStyle(
        fontSize: 13.0,
        fontWeight: FontWeight.w400,
        height: 15.0 / 13.0,
        color: mode == ThemeMode.light
            ? ColorConstants.light.textBlack
            : ColorConstants.light.textBlack,
      ),
      bodySmall: TextStyle(
        fontSize: 10.0,
        fontWeight: FontWeight.w400,
        height: 12.0 / 10.0,
        color: mode == ThemeMode.light
            ? ColorConstants.light.textBlack
            : ColorConstants.light.textBlack,
      ),

      /// Service (button) texts
      displayMedium: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        height: 16.0 / 14.0,
        color: mode == ThemeMode.light
            ? ColorConstants.light.textWhite
            : ColorConstants.light.textWhite,
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
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        height: 21.0 / 14.0,
        color: mode == ThemeMode.light
            ? ColorConstants.light.textFieldText
            : ColorConstants.light.textFieldText,
      ),
      hintStyle: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        height: 21.0 / 14.0,
        color: mode == ThemeMode.light
            ? ColorConstants.light.textFieldTextHint
            : ColorConstants.light.textFieldTextHint,
      ),
      errorStyle: TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w400,
        height: 21.0 / 12.0,
        color: mode == ThemeMode.light
            ? ColorConstants.light.textFieldError
            : ColorConstants.light.textFieldError,
      ),
      helperStyle: TextStyle(
        fontSize: 12.0,
        height: 21.0 / 12.0,
        fontWeight: FontWeight.w400,
        color: mode == ThemeMode.light
            ? ColorConstants.light.textFieldText
            : ColorConstants.light.textFieldText,
      ),
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: mode == ThemeMode.light
              ? ColorConstants.light.textFieldBorder
              : ColorConstants.light.textFieldBorder,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: mode == ThemeMode.light
              ? ColorConstants.light.textFieldFocusedBorder
              : ColorConstants.light.textFieldFocusedBorder,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: mode == ThemeMode.light
              ? ColorConstants.light.textFieldBorder
              : ColorConstants.light.textFieldBorder,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: mode == ThemeMode.light
              ? ColorConstants.light.textFieldError
              : ColorConstants.light.textFieldError,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: mode == ThemeMode.light
              ? ColorConstants.light.textFieldError
              : ColorConstants.light.textFieldError,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
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
