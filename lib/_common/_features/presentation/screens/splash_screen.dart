part of '../../../common.dart';

class SplashScreen extends StatelessWidget {
  static const routePath = '/';

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      options: ScaffoldWrapperOptions(
        withKeyboardResize: false,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: ColorConstants.splashBG(),
            ),
          ),
          Center(
            child: CustomProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
