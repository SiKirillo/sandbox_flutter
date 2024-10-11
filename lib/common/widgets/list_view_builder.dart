part of '../common.dart';

class CustomListViewBuilder<T> extends StatelessWidget {
  final ScrollController? controller;
  final int itemCount;
  final EdgeInsets padding;
  final Axis scrollDirection;
  final bool shrinkWrap;
  final bool isScrollEnabled;
  final bool isReversed;
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
    this.isReversed = false,
    this.separatorBuilder,
    required this.itemBuilder,
  }) : assert(itemCount >= 0);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: controller,
      itemCount: itemCount,
      physics: isScrollEnabled
          ? const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics())
          : const NeverScrollableScrollPhysics(),
      scrollDirection: scrollDirection,
      shrinkWrap: shrinkWrap,
      reverse: isReversed,
      padding: padding,
      itemBuilder: itemBuilder,
      separatorBuilder: separatorBuilder ?? (_, index) {
        return const SizedBox();
      },
    );
  }
}
