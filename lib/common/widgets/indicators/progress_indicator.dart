import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../constants/images.dart';

/// This is custom implementation of basic progress indicator
/// You can replace [CircularProgressIndicator] with another widget
class CustomProgressIndicator extends StatefulWidget {
  final double size;
  final double? progressValue;
  final Color? color;

  const CustomProgressIndicator({
    super.key,
    this.size = 20.0,
    this.progressValue,
    this.color,
  })  : assert(size >= 0),
        assert(progressValue == null || progressValue >= 0);

  @override
  State<CustomProgressIndicator> createState() => _CustomProgressIndicatorState();
}

class _CustomProgressIndicatorState extends State<CustomProgressIndicator> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Transform.rotate(
          angle: (widget.progressValue ?? _controller.value) * 2 * math.pi,
          child: child,
        );
      },
      child: SizedBox.square(
        dimension: widget.size,
        child: Image.asset(
          ImageConstants.icProgress,
          color: widget.color ?? Theme.of(context).indicatorColor,
        ),
      ),
    );
  }
}
