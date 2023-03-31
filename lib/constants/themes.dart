import 'dart:io';

import 'package:flutter/material.dart';

import '../common/providers/theme_provider.dart';
import 'colors.dart';

class ThemeConstants {
  static ThemeData getTheme(ThemeStyleType type) {
    switch (type) {
      case ThemeStyleType.light:
      return ThemeData.lerp(ThemeData.light(), _lightTheme, 1.0);

      case ThemeStyleType.dark:
      return ThemeData.lerp(ThemeData.dark(), _darkTheme, 1.0);
    }
  }

  static final _lightTheme = ThemeData(
    fontFamily: Platform.isAndroid ? 'Roboto' : 'OpenSans',
    brightness: Brightness.light,
    scaffoldBackgroundColor: ColorConstants.light.blue100,
    canvasColor: ColorConstants.light.blue100,
    appBarTheme: AppBarTheme(
      backgroundColor: ColorConstants.light.blue200,
      shadowColor: ColorConstants.light.blue200.withOpacity(0.6),
      elevation: 0.0,
      titleTextStyle: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        height: 18.0 / 16.0,
        color: ColorConstants.light.black500,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: ColorConstants.light.blue400,
    ),
    tabBarTheme: TabBarTheme(
      indicatorColor: ColorConstants.light.green500,
      labelStyle: TextStyle(
        color: ColorConstants.light.green500,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        height: 21.0 / 14.0,
      ),
      unselectedLabelStyle: TextStyle(
        color: ColorConstants.light.green500,
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        height: 21.0 / 14.0,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: ColorConstants.light.black450,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: ColorConstants.light.black450,
      titleTextStyle: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w700,
        height: 28.0 / 24.0,
        color: ColorConstants.light.black500,
      ),
    ),
    textTheme: _getTextThemeByType(ThemeStyleType.light),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      errorMaxLines: 3,
      helperMaxLines: 3,
      contentPadding: const EdgeInsets.all(16.0),
      iconColor: ColorConstants.light.blue300,
      fillColor: ColorConstants.light.blue100,
      labelStyle: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        height: 21.0 / 16.0,
        color: ColorConstants.light.black500,
      ),
      hintStyle: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        height: 21.0 / 16.0,
        color: ColorConstants.light.black500.withOpacity(0.5),
      ),
      errorStyle: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        height: 21.0 / 14.0,
        color: ColorConstants.light.red500,
      ),
      helperStyle: TextStyle(
        fontSize: 13.0,
        height: 21.0 / 13.0,
        fontWeight: FontWeight.w400,
        color: ColorConstants.light.black500.withOpacity(0.6),
      ),
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: ColorConstants.light.blue300,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: ColorConstants.light.blue300,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: ColorConstants.light.blue300,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: ColorConstants.light.red500,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: ColorConstants.light.red500,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: ColorConstants.light.grey100.withOpacity(0.6),
        ),
      ),
    ),
    iconTheme: IconThemeData(
      color: ColorConstants.light.blue300,
    ),
    dividerTheme: DividerThemeData(
      color: ColorConstants.light.divider,
    ),
  );

  static final _darkTheme = ThemeData(
    fontFamily: Platform.isAndroid ? 'Roboto' : 'OpenSans',
    brightness: Brightness.dark,
    scaffoldBackgroundColor: ColorConstants.dark.blue400,
    canvasColor: ColorConstants.dark.blue400,
    appBarTheme: AppBarTheme(
      backgroundColor: ColorConstants.dark.blue200,
      shadowColor: ColorConstants.dark.blue200.withOpacity(0.6),
      elevation: 0.0,
      titleTextStyle: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        height: 18.0 / 16.0,
        color: ColorConstants.dark.black500,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: ColorConstants.dark.grey200,
    ),
    tabBarTheme: TabBarTheme(
      indicatorColor: ColorConstants.dark.green500,
      labelStyle: TextStyle(
        color: ColorConstants.dark.green500,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        height: 21.0 / 14.0,
      ),
      unselectedLabelStyle: TextStyle(
        color: ColorConstants.dark.green500,
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        height: 21.0 / 14.0,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: ColorConstants.dark.black450,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: ColorConstants.dark.black450,
      titleTextStyle: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w700,
        height: 28.0 / 24.0,
        color: ColorConstants.dark.black500,
      ),
    ),
    textTheme: _getTextThemeByType(ThemeStyleType.dark),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      errorMaxLines: 3,
      helperMaxLines: 3,
      contentPadding: const EdgeInsets.all(16.0),
      iconColor: ColorConstants.dark.blue300,
      fillColor: ColorConstants.dark.blue400,
      labelStyle: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        height: 21.0 / 16.0,
        color: ColorConstants.dark.white500,
      ),
      hintStyle: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        height: 21.0 / 16.0,
        color: ColorConstants.dark.white500.withOpacity(0.5),
      ),
      errorStyle: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        height: 21.0 / 14.0,
        color: ColorConstants.dark.red500,
      ),
      helperStyle: TextStyle(
        fontSize: 13.0,
        height: 21.0 / 13.0,
        fontWeight: FontWeight.w400,
        color: ColorConstants.dark.white500.withOpacity(0.6),
      ),
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: ColorConstants.dark.blue300,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: ColorConstants.dark.blue300,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: ColorConstants.dark.blue300,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: ColorConstants.dark.red500,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: ColorConstants.dark.red500,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          width: 1.0,
          color: ColorConstants.dark.grey100.withOpacity(0.6),
        ),
      ),
    ),
    iconTheme: IconThemeData(
      color: ColorConstants.dark.blue300,
    ),
    dividerTheme: DividerThemeData(
      color: ColorConstants.dark.divider,
    ),
  );

  static TextTheme _getTextThemeByType(ThemeStyleType type) {
    return TextTheme(
      /// Only for headline labels
      headlineLarge: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.w700,
        height: 33.0 / 28.0,
        color: type == ThemeStyleType.light
            ? ColorConstants.light.black500
            : ColorConstants.dark.white500,
      ),
      headlineMedium: TextStyle(
        fontSize: 21.0,
        fontWeight: FontWeight.w700,
        height: 25.0 / 21.0,
        color: type == ThemeStyleType.light
            ? ColorConstants.light.black500
            : ColorConstants.dark.white500,
      ),
      headlineSmall: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w700,
        height: 21.0 / 18.0,
        color: type == ThemeStyleType.light
            ? ColorConstants.light.black500
            : ColorConstants.dark.white500,
      ),

      /// Default texts
      bodyLarge: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        height: 21.0 / 16.0,
        color: type == ThemeStyleType.light
            ? ColorConstants.light.black500
            : ColorConstants.dark.white500,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        height: 21.0 / 14.0,
        color: type == ThemeStyleType.light
            ? ColorConstants.light.black500
            : ColorConstants.dark.white500,
      ),
      bodySmall: TextStyle(
        fontSize: 13.0,
        fontWeight: FontWeight.w400,
        height: 21.0 / 13.0,
        color: type == ThemeStyleType.light
            ? ColorConstants.light.black500
            : ColorConstants.dark.white500,
      ),

      /// Service texts
      displayMedium: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        height: 18.0 / 16.0,
        color: type == ThemeStyleType.light
            ? ColorConstants.light.black500
            : ColorConstants.dark.white500,
      ),
      displaySmall: TextStyle(
        fontSize: 13.0,
        fontWeight: FontWeight.w400,
        height: 18.0 / 13.0,
        color: type == ThemeStyleType.light
            ? ColorConstants.light.black500
            : ColorConstants.dark.white500,
      ),
    );
  }
}
