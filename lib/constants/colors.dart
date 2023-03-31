import 'package:flutter/material.dart';

class ColorConstants {
  static const light = _LightColorData(
    red500: Color(0xFFFF003D),
    green500: Color(0xFF289D83),
    blue400: Color(0xFF3877A4),
    blue300: Color(0xFF5794C1),
    blue200: Color(0xFF9DD6FF),
    blue100: Color(0xFFE4F1FF),
    grey100: Color(0xFF9DB0BD),
    black500: Color(0xFF000000),
    black450: Color(0xFF141718),
    black400: Color(0xFF1C1C1C),
    white500: Color(0xFFFFFFFF),
    divider: Color(0xFF323C3F),
  );

  static const dark = _DarkColorData(
    red500: Color(0xFFFF003D),
    green500: Color(0xFF289D83),
    blue400: Color(0xFF001D31),
    blue300: Color(0xFF0C5789),
    blue200: Color(0xFF9DD6FF),
    blue100: Color(0xFFE4F1FF),
    grey200: Color(0xFF2F3438),
    grey100: Color(0xFF5B656C),
    black500: Color(0xFF000000),
    black450: Color(0xFF141718),
    black400: Color(0xFF1C1C1C),
    white500: Color(0xFFFFFFFF),
    white400: Color(0xFFF3F3F3),
    divider: Color(0xFF323C3F),
  );

  /// Service
  static const transparent = Color(0x00000000);
  static const systemNavigationBar = Color(0xFF000000);
}

class _LightColorData {
  /// Red
  final Color red500;

  /// Green
  final Color green500;

  /// Blue
  final Color blue400;
  final Color blue300;
  final Color blue200;
  final Color blue100;

  /// Grey
  final Color grey100;

  /// Black
  final Color black500;
  final Color black450;
  final Color black400;

  /// White
  final Color white500;

  /// Service
  final Color divider;

  const _LightColorData({
    required this.red500,
    required this.green500,
    required this.blue400,
    required this.blue300,
    required this.blue200,
    required this.blue100,
    required this.grey100,
    required this.black500,
    required this.black450,
    required this.black400,
    required this.white500,
    required this.divider,
  });
}

class _DarkColorData {
  /// Red
  final Color red500;

  /// Green
  final Color green500;

  /// Blue
  final Color blue400;
  final Color blue300;
  final Color blue200;
  final Color blue100;

  /// Grey
  final Color grey200;
  final Color grey100;

  /// Black
  final Color black500;
  final Color black450;
  final Color black400;

  /// White
  final Color white500;
  final Color white400;

  /// Service
  final Color divider;

  const _DarkColorData({
    required this.red500,
    required this.green500,
    required this.blue400,
    required this.blue300,
    required this.blue200,
    required this.blue100,
    required this.grey200,
    required this.grey100,
    required this.black500,
    required this.black450,
    required this.black400,
    required this.white500,
    required this.white400,
    required this.divider,
  });
}