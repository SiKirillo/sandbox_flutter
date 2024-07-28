import 'package:flutter/material.dart';

class CustomListViewBuilder extends StatelessWidget {
  final ScrollController? controller;
  final int itemCount;
  final EdgeInsets padding;
  final Axis scrollDirection;
  final bool shrinkWrap;
  final bool isDisabled;
  final bool isReversed;
  final Widget Function(BuildContext, int) itemBuilder;
  final Widget Function(BuildContext, int)? separatorBuilder;

  const CustomListViewBuilder({
    super.key,
    this.controller,
    required this.itemCount,
    this.padding = EdgeInsets.zero,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = false,
    this.isDisabled = false,
    this.isReversed = false,
    required this.itemBuilder,
    this.separatorBuilder,
  })  : assert(itemCount >= 1);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: controller,
      itemCount: itemCount,
      physics: !isDisabled
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
