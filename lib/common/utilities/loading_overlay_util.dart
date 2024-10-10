part of '../common.dart';

class LoadingOverlayUtil {
  static OverlayEntry? _overlay;

  static void show(BuildContext context) {
    if (_overlay == null) {
      _overlay = OverlayEntry(
        builder: (context) => ColoredBox(
          color: ColorConstants.overlay(),
          child: const Center(child: CustomProgressIndicator()),
        ),
      );
      Overlay.of(context).insert(_overlay!);
    }
  }

  static void hide() {
    if (_overlay != null) {
      _overlay!.remove();
      _overlay = null;
    }
  }
}
