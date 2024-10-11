part of '../common.dart';

class CustomPageIndicator extends StatelessWidget {
  final int activeIndex;
  final int count;

  const CustomPageIndicator({
    super.key,
    required this.activeIndex,
    required this.count,
  }) : assert(activeIndex >= 0 && count >= 0);

  @override
  Widget build(BuildContext context) {
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: count,
      effect: ExpandingDotsEffect(
        dotHeight: 10.0,
        dotWidth: 10.0,
        spacing: 6.0,
        radius: 10.0,
        activeDotColor: ColorConstants.pageIndicatorActiveColor(),
        dotColor: ColorConstants.pageIndicatorDisableColor(),
      ),
    );
  }
}
