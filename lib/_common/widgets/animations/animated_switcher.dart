part of '../../common.dart';

class CustomAnimatedSwitcher extends StatelessWidget {
  final Duration duration;
  final Curve animation;
  final Alignment alignment;
  final Widget child;

  const CustomAnimatedSwitcher({
    super.key,
    this.duration = const Duration(milliseconds: 300),
    this.animation = Curves.easeInOut,
    this.alignment = Alignment.center,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: animation,
      switchOutCurve: animation,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(animation),
          child: child,
        );
      },
      layoutBuilder: (child, previousChildren) {
        return Stack(
          alignment: alignment,
          children: <Widget>[
            ...previousChildren,
            if (child != null) child,
          ],
        );
      },
      child: child,
    );
  }
}
