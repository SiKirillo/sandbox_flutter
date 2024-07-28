import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/material.dart';

import '../../../constants/style.dart';

class CustomAnimatedSizeAndFade extends StatelessWidget {
  final Widget child;
  final Duration duration;

  const CustomAnimatedSizeAndFade({
    super.key,
    required this.child,
    this.duration = StyleConstants.defaultAnimationDuration,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSizeAndFade(
      fadeDuration: duration,
      sizeDuration: duration,
      child: child,
    );
  }
}
