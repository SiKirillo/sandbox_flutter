import 'package:flutter/material.dart';

import '../common/services/gifs_builder_service.dart';
import '../common/widgets/wrappers/scaffold_wrapper.dart';
import '../constants/images.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onFinish;

  const SplashScreen({
    Key? key,
    required this.onFinish,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final GifController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GifController(isLoop: true);
    _controller.play();

    Future.delayed(const Duration(seconds: 2)).then((_) {
      _controller.stop();
      widget.onFinish();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Use the same values as in android/ios launch screens
    const imageHeight = 120.0;
    const imageWidth = 93.0;

    return ScaffoldWrapper(
      child: Center(
        child: SizedBox(
          height: imageHeight,
          width: imageWidth,
          child: GifsBuilderService.asset(
            ImageConstants.igPartyCat,
            controller: _controller,
            frameRate: 10,
            onLoading: SizedBox(
              height: imageHeight,
              width: imageWidth,
              child: Image.asset(ImageConstants.imPartyCat),
            ),
          ),
        ),
      ),
    );
  }
}
