part of '../../common.dart';

class CustomAnimatedSwitcher extends StatelessWidget {
  final ValueKey<dynamic> valueKey;
  final int previousIndex, currentIndex;
  final Widget child;

  const CustomAnimatedSwitcher({
    super.key,
    required this.valueKey,
    required this.previousIndex,
    required this.currentIndex,
    required this.child,
  });

  static const animationDuration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: CustomAnimatedSwitcher.animationDuration,
      transitionBuilder: (child, animation) {
        final isCurrentWidget = valueKey == child.key;
        final isSlideToLeft = currentIndex > previousIndex;

        final beginOffsetSlideToLeft = isCurrentWidget ? 1.1 : -1.1;
        final beginOffsetSlideToRight = isCurrentWidget ? -1.1 : 1.1;

        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(isSlideToLeft ? beginOffsetSlideToLeft : beginOffsetSlideToRight, 0.0),
            end: const Offset(0.0, 0.0),
          ).animate(animation),
          child: child,
        );
      },
      child: child,
    );
  }
}
