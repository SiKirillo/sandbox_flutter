import 'package:flutter/material.dart';

/// Use this if you want to have shadow animation when you make any requests
class OpacityWrapper extends StatelessWidget {
  final bool isOpaque;
  final double opacity;
  final Widget child;

  const OpacityWrapper({
    Key? key,
    required this.isOpaque,
    this.opacity = 0.5,
    required this.child,
  })  : assert(opacity >= 0.0 && opacity <= 1.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isOpaque ? opacity : 1.0,
      child: child,
    );
  }
}
