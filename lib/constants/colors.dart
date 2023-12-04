import 'package:flutter/material.dart';

import '../common/providers/theme_provider.dart';
import '../injection_container.dart';

class ColorConstants {
  static final light = _LightColorTheme();
  static final dark = _DarkColorTheme();
  static bool get _isLightTheme => !locator<ThemeProvider>().isDark;

  /// Service
  static const transparent = Color(0x00000000);
  static const systemNavigationBar = Color(0xFF000000);

  /// Button
  static Color buttonColor() => _isLightTheme ? light.buttonColor : dark.buttonColor;

  /// Progress
  static List<Color> progressBarGradient() => _isLightTheme ? light.progressBarGradient : dark.progressBarGradient;
}

class _LightColorTheme {
  /// Background
  final bgScaffold = const Color(0xFFF1F3F7);
  final bgDialogs = const Color(0xFFFFFFFF);

  /// Button
  final buttonColor = const Color(0xFF00454F).withOpacity(0.5);

  /// Progress
  final progressBarGradient = const <Color>[
    Color(0xFFFD023F),
    Color(0xFF0099D8),
    Color(0xFF289D83),
  ];
}

class _DarkColorTheme {
  /// Background
  final bgScaffold = const Color(0xFF000000);
  final bgDialogs = const Color(0xFF141718);

  /// Button
  final buttonColor = const Color(0xFF00454F).withOpacity(0.5);

  /// Progress
  final progressBarGradient = const <Color>[
    Color(0xFFFD023F),
    Color(0xFF0099D8),
    Color(0xFF289D83),
  ];
}