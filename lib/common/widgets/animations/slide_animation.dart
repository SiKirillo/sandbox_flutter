part of '../../common.dart';

class CustomSlideAnimation extends StatelessWidget {
  final Duration duration;
  final Curve animation;
  final Widget child;

  const CustomSlideAnimation({
    super.key,
    this.duration = const Duration(milliseconds: 500),
    this.animation = Curves.easeInOut,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: animation,
      switchOutCurve: animation,
      child: child,
    );
  }
}
