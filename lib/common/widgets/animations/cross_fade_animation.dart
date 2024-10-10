part of '../../common.dart';

class CustomCrossFadeAnimation extends StatelessWidget {
  final Duration duration;
  final Curve animation;
  final bool showFirst;
  final Widget firstChild;
  final Widget secondChild;

  const CustomCrossFadeAnimation({
    super.key,
    this.duration = const Duration(milliseconds: 500),
    this.animation = Curves.easeInOut,
    this.showFirst = true,
    required this.firstChild,
    required this.secondChild,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: duration,
      firstCurve: animation,
      secondCurve: animation,
      crossFadeState: showFirst
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      firstChild: firstChild,
      secondChild: secondChild,
    );
  }
}
