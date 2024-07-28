import 'package:flutter/material.dart';

import '../../../injection_container.dart';
import '../../services/device_service.dart';

class DevBuildVersionBackground extends StatelessWidget {
  const DevBuildVersionBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BannerPainter(
        message: locator<DeviceService>().currentBuildBanner(),
        textDirection: Directionality.of(context),
        layoutDirection: Directionality.of(context),
        location: BannerLocation.bottomEnd,
      ),
    );
  }
}
