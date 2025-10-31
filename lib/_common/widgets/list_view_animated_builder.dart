part of '../common.dart';

class CustomListViewAnimatedBuilder<T> extends StatelessWidget {
  final ScrollController? controller;
  final int initialItemCount;
  final EdgeInsets padding;
  final Axis scrollDirection;
  final bool shrinkWrap;
  final bool isScrollEnabled, isScrollbarVisible;
  final bool isReversed;
  final Widget Function(BuildContext, int, Animation<double>) separatorBuilder;
  final Widget Function(BuildContext, int, Animation<double>) removedSeparatorBuilder;
  final Widget Function(BuildContext, int, Animation<double>) itemBuilder;

  const CustomListViewAnimatedBuilder({
    super.key,
    this.controller,
    required this.initialItemCount,
    this.padding = EdgeInsets.zero,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = false,
    this.isScrollEnabled = true,
    this.isScrollbarVisible = false,
    this.isReversed = false,
    required this.separatorBuilder,
    required this.removedSeparatorBuilder,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollbar(
      isScrollbarVisible: isScrollbarVisible,
      child: AnimatedList.separated(
        controller: controller,
        initialItemCount: initialItemCount,
        physics: isScrollEnabled
            ? OtherConstants.defaultScrollPhysics
            : NeverScrollableScrollPhysics(),
        scrollDirection: scrollDirection,
        shrinkWrap: shrinkWrap,
        reverse: isReversed,
        padding: padding,
        itemBuilder: itemBuilder,
        separatorBuilder: separatorBuilder,
        removedSeparatorBuilder: removedSeparatorBuilder,
      ),
    );
  }
}
