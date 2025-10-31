part of '../../common.dart';

class DevBuildVersionPlaceholder extends StatelessWidget {
  const DevBuildVersionPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BannerPainter(
        message: locator<DeviceService>().getBuildPlaceholderLabel(),
        textDirection: Directionality.of(context),
        layoutDirection: Directionality.of(context),
        location: BannerLocation.bottomEnd,
      ),
    );
  }
}
