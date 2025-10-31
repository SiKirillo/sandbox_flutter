part of '../common.dart';

class CustomListViewBuilder<T> extends StatelessWidget {
  final ScrollController? controller;
  final int itemCount;
  final EdgeInsets padding;
  final Axis scrollDirection;
  final bool shrinkWrap;
  final bool isScrollEnabled, isScrollbarVisible;
  final bool isReversed;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final Widget Function(BuildContext, int)? separatorBuilder;
  final Widget Function(BuildContext, int) itemBuilder;

  const CustomListViewBuilder({
    super.key,
    this.controller,
    required this.itemCount,
    this.padding = EdgeInsets.zero,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = false,
    this.isScrollEnabled = true,
    this.isScrollbarVisible = false,
    this.isReversed = false,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.separatorBuilder,
    required this.itemBuilder,
  }) : assert(itemCount >= 0);

  @override
  Widget build(BuildContext context) {
    return CustomScrollbar(
      isScrollbarVisible: isScrollbarVisible,
      child: ListView.separated(
        controller: controller,
        itemCount: itemCount,
        physics: isScrollEnabled
            ? OtherConstants.defaultScrollPhysics
            : NeverScrollableScrollPhysics(),
        scrollDirection: scrollDirection,
        shrinkWrap: shrinkWrap,
        reverse: isReversed,
        padding: padding,
        keyboardDismissBehavior: keyboardDismissBehavior,
        itemBuilder: itemBuilder,
        separatorBuilder: separatorBuilder ?? (_, index) {
          return SizedBox();
        },
      ),
    );
  }
}
