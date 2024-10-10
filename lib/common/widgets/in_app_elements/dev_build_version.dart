part of '../../common.dart';

class DevBuildVersionBackground extends StatelessWidget {
  const DevBuildVersionBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BannerPainter(
        message: locator<DeviceService>().getBuildBanner(),
        textDirection: Directionality.of(context),
        layoutDirection: Directionality.of(context),
        location: BannerLocation.bottomEnd,
      ),
    );
  }
}
