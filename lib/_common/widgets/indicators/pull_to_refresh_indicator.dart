part of '../../common.dart';

class CustomPullToRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final double size;
  final Widget child;

  const CustomPullToRefreshIndicator({
    super.key,
    required this.onRefresh,
    this.size = 30.0,
    required this.child,
  }) : assert(size >= 0);

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      onRefresh: onRefresh,
      builder: (_, child, controller) {
        return Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            AnimatedBuilder(
              animation: controller,
              builder: (_, child) {
                return SizedBox(
                  height: controller.value * size,
                  child: Opacity(
                    opacity: 0.5,
                    child: CustomProgressIndicator(),
                  ),
                );
              },
            ),
            Transform.translate(
              offset: Offset(0.0, controller.value * size),
              child: child,
            ),
          ],
        );
      },
      child: child,
    );
  }
}
