import 'dart:io';

import 'package:flutter/material.dart';

import 'colors.dart';

class ThemeConstants {
  static ThemeData get light => ThemeData.lerp(ThemeData.light(), _lightTheme, 1.0);
  static ThemeData get dark => ThemeData.lerp(ThemeData.dark(), _darkTheme, 1.0);

  static final _lightTheme = ThemeData(
    fontFamily: Platform.isAndroid ? 'Roboto' : 'OpenSans',
    brightness: Brightness.light,
    scaffoldBackgroundColor: ColorConstants.light.bgScaffold,
    canvasColor: ColorConstants.light.bgScaffold,
    appBarTheme: AppBarTheme(
      backgroundColor: ColorConstants.light.bgScaffold,
      shadowColor: ColorConstants.light.bgScaffold.withOpacity(0.6),
      elevation: 0.0,
      titleTextStyle: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        height: 18.0 / 16.0,
        color: ColorConstants.light.bgScaffold,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: ColorConstants.light.bgScaffold,
    ),
    tabBarTheme: TabBarTheme(
      indicatorColor: ColorConstants.light.bgScaffold,
      labelStyle: TextStyle(
        color: ColorConstants.light.bgScaffold,
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        height: 21.0 / 14.0,
      ),
      unselectedLabelStyle: TextStyle(
        color: ColorConstants.light.bgScaffold.withOpacity(0.6),
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        height: 21.0 / 14.0,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: ColorConstants.light.bgScaffold,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: ColorConstants.light.bgScaffold,
      titleTextStyle: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w700,
        height: 28.0 / 24.0,
        color: ColorConstants.light.bgScaffold,
      ),
    ),
    textTheme: _getTextThemeByType(ThemeMode.light),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      errorMaxLines: 3,
      helperMaxLines: 3,
      contentPadding: const EdgeInsets.all(16.0),
      iconColor: ColorConstants.light.bgScaffold,
      fillColor: ColorConstants.light.bgScaffold,
      labelStyle: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        height: 21.0 / 16.0,
        color: ColorConstants.light.bgScaffold,
      ),
      hintStyle: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        height: 21.0 / 16.0,
        color: ColorConstants.light.bgScaffold.withOpacity(0.5),
      ),
      errorStyle: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        height: 21.0 / 14.0,
        color: ColorConstants.light.bgScaffold,
      ),
      helperStyle: TextStyle(
        fontSize: 13.0,
        height: 21.0 / 13.0,
        fontWeight: FontWeight.w400,
        color: ColorConstants.light.bgScaffold.withOpacity(0.6),
      ),
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: ColorConstants.light.bgScaffold,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: ColorConstants.light.bgScaffold,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: ColorConstants.light.bgScaffold,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: ColorConstants.light.bgScaffold,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: ColorConstants.light.bgScaffold,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: ColorConstants.light.bgScaffold.withOpacity(0.6),
        ),
      ),
    ),
    iconTheme: IconThemeData(
      color: ColorConstants.light.bgScaffold,
    ),
    dividerTheme: DividerThemeData(
      color: ColorConstants.light.bgScaffold,
    ),
    indicatorColor: ColorConstants.light.bgScaffold,
    listTileTheme: ListTileThemeData(
      tileColor: ColorConstants.light.bgScaffold,
    ),
  );

  static final _darkTheme = ThemeData(
    fontFamily: Platform.isAndroid ? 'Roboto' : 'OpenSans',
    brightness: Brightness.dark,
    scaffoldBackgroundColor: ColorConstants.dark.bgScaffold,
    canvasColor: ColorConstants.dark.bgScaffold,
    appBarTheme: AppBarTheme(
      backgroundColor: ColorConstants.dark.bgScaffold,
      shadowColor: ColorConstants.dark.bgScaffold.withOpacity(0.6),
      elevation: 0.0,
      titleTextStyle: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        height: 18.0 / 16.0,
        color: ColorConstants.dark.bgScaffold,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: ColorConstants.dark.bgScaffold,
    ),
    tabBarTheme: TabBarTheme(
      indicatorColor: ColorConstants.dark.bgScaffold,
      labelStyle: TextStyle(
        color: ColorConstants.dark.bgScaffold,
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        height: 21.0 / 14.0,
      ),
      unselectedLabelStyle: TextStyle(
        color: ColorConstants.dark.bgScaffold.withOpacity(0.6),
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        height: 21.0 / 14.0,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: ColorConstants.dark.bgScaffold,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: ColorConstants.dark.bgScaffold,
      titleTextStyle: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w700,
        height: 28.0 / 24.0,
        color: ColorConstants.dark.bgScaffold,
      ),
    ),
    textTheme: _getTextThemeByType(ThemeMode.dark),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      errorMaxLines: 3,
      helperMaxLines: 3,
      contentPadding: const EdgeInsets.all(16.0),
      iconColor: ColorConstants.dark.bgScaffold,
      fillColor: ColorConstants.dark.bgScaffold,
      labelStyle: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        height: 21.0 / 16.0,
        color: ColorConstants.dark.bgScaffold,
      ),
      hintStyle: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        height: 21.0 / 16.0,
        color: ColorConstants.dark.bgScaffold.withOpacity(0.5),
      ),
      errorStyle: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        height: 21.0 / 14.0,
        color: ColorConstants.dark.bgScaffold,
      ),
      helperStyle: TextStyle(
        fontSize: 13.0,
        height: 21.0 / 13.0,
        fontWeight: FontWeight.w400,
        color: ColorConstants.dark.bgScaffold.withOpacity(0.6),
      ),
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: ColorConstants.dark.bgScaffold,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: ColorConstants.dark.bgScaffold,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: ColorConstants.dark.bgScaffold,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: ColorConstants.dark.bgScaffold,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: ColorConstants.dark.bgScaffold,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: ColorConstants.dark.bgScaffold.withOpacity(0.6),
        ),
      ),
    ),
    iconTheme: IconThemeData(
      color: ColorConstants.dark.bgScaffold,
    ),
    dividerTheme: DividerThemeData(
      color: ColorConstants.dark.bgScaffold,
    ),
    indicatorColor: ColorConstants.dark.bgScaffold,
    listTileTheme: ListTileThemeData(
      tileColor: ColorConstants.dark.bgScaffold,
    ),
  );

  static TextTheme _getTextThemeByType(ThemeMode mode) {
    return TextTheme(
      /// Only for headline labels
      headlineLarge: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.w700,
        height: 33.0 / 28.0,
        color: mode == ThemeMode.light
            ? ColorConstants.light.bgScaffold
            : ColorConstants.dark.bgScaffold,
      ),
      headlineMedium: TextStyle(
        fontSize: 21.0,
        fontWeight: FontWeight.w700,
        height: 25.0 / 21.0,
        color: mode == ThemeMode.light
            ? ColorConstants.light.bgScaffold
            : ColorConstants.dark.bgScaffold,
      ),
      headlineSmall: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w700,
        height: 21.0 / 18.0,
        color: mode == ThemeMode.light
            ? ColorConstants.light.bgScaffold
            : ColorConstants.dark.bgScaffold,
      ),

      /// Default texts
      bodyLarge: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        height: 21.0 / 16.0,
        color: mode == ThemeMode.light
            ? ColorConstants.light.bgScaffold
            : ColorConstants.dark.bgScaffold,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        height: 21.0 / 14.0,
        color: mode == ThemeMode.light
            ? ColorConstants.light.bgScaffold
            : ColorConstants.dark.bgScaffold,
      ),
      bodySmall: TextStyle(
        fontSize: 13.0,
        fontWeight: FontWeight.w400,
        height: 21.0 / 13.0,
        color: mode == ThemeMode.light
            ? ColorConstants.light.bgScaffold
            : ColorConstants.dark.bgScaffold,
      ),

      /// Service texts
      displayMedium: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        height: 18.0 / 16.0,
        color: mode == ThemeMode.light
            ? ColorConstants.light.bgScaffold
            : ColorConstants.dark.bgScaffold,
      ),
      displaySmall: TextStyle(
        fontSize: 13.0,
        fontWeight: FontWeight.w400,
        height: 18.0 / 13.0,
        color: mode == ThemeMode.light
            ? ColorConstants.light.bgScaffold
            : ColorConstants.dark.bgScaffold,
      ),
    );
  }
}
