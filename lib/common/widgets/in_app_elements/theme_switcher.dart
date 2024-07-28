import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../injection_container.dart';
import '../../models/app_settings_model.dart';
import '../../providers/theme_provider.dart';
import '../../usecases/core_update_settings.dart';

class ThemeSwitcherBackground extends StatelessWidget {
  const ThemeSwitcherBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final currentMode = context.watch<ThemeProvider>().mode;
    return GestureDetector(
      onTap: () {
        final currentModeIndex = context.read<ThemeProvider>().mode.index;
        final nextModeIndex = currentModeIndex == 2 ? 0 : currentModeIndex + 1;

        locator<CoreUpdateSettings>().call(AppSettingsData(
          themeMode: ThemeMode.values[nextModeIndex],
        ));
      },
      child: Container(
        height: 50.0,
        width: 50.0,
        color: Colors.transparent,
        child: CustomPaint(
          painter: BannerPainter(
            message: context.watch<ThemeProvider>().mode.toString().split('.').last,
            textDirection: Directionality.of(context),
            layoutDirection: Directionality.of(context),
            color: currentMode == ThemeMode.system ? Colors.orange.withOpacity(0.8) : currentMode == ThemeMode.dark ? Colors.red.withOpacity(0.8) : Colors.green.withOpacity(0.8),
            location: BannerLocation.bottomStart,
          ),
        ),
      ),
    );
  }
}
