import 'package:flutter/material.dart';

class AppSettingsData {
  final ThemeMode? themeMode;
  final bool? isCharlesProxyEnabled;
  final bool? isNetworkEnabled;
  final String? proxyIP;

  const AppSettingsData({
    this.themeMode,
    this.isCharlesProxyEnabled,
    this.isNetworkEnabled,
    this.proxyIP,
  });
}