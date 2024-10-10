part of '../../common.dart';

class OpacityWrapper extends StatelessWidget {
  final bool isOpaque;
  final double opacity;
  final Widget child;

  const OpacityWrapper({
    super.key,
    required this.isOpaque,
    this.opacity = 0.5,
    required this.child,
  }) : assert(opacity >= 0.0 && opacity <= 1.0);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: StyleConstants.defaultAnimationDuration,
      opacity: isOpaque ? opacity : 1.0,
      child: child,
    );
  }
}
