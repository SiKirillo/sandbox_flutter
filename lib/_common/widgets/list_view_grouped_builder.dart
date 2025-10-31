part of '../common.dart';

class CustomGroupedListViewBuilder<T, E> extends StatelessWidget {
  final ScrollController? controller;
  final List<T> items;
  final EdgeInsets padding;
  final Axis scrollDirection;
  final bool shrinkWrap;
  final bool isScrollEnabled, isScrollbarVisible;
  final bool isReversed;
  final E Function(T element) groupBy;
  final bool Function(T element, E value) groupSort;
  final int Function(E a, E b)? groupComparator;
  final int Function(T a, T b)? itemComparator;
  final Widget Function(BuildContext, E)? groupBuilder;
  final Widget Function(BuildContext, E, List<T>, int)? groupCustomBuilder;
  final Widget Function(BuildContext, int)? groupSeparatorBuilder;
  final Widget Function(BuildContext, T)? itemBuilder;
  final Widget Function(BuildContext, int)? itemSeparatorBuilder;

  const CustomGroupedListViewBuilder({
    super.key,
    this.controller,
    required this.items,
    this.padding = EdgeInsets.zero,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = false,
    this.isScrollEnabled = true,
    this.isScrollbarVisible = false,
    this.isReversed = false,
    required this.groupBy,
    required this.groupSort,
    this.groupComparator,
    this.itemComparator,
    this.groupSeparatorBuilder,
    required this.groupBuilder,
    this.groupCustomBuilder,
    this.itemSeparatorBuilder,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final preparedGroups = items.map(groupBy).toList()..sort(groupComparator);
    final sortedGroups = preparedGroups.toSet();
    final sortedItems = <E, List<T>>{};

    for (final group in sortedGroups) {
      final preparedItems = items.where((item) => groupSort(item, group)).toList();
      if (itemComparator != null) {
        preparedItems.sort(itemComparator);
      }
      sortedItems.putIfAbsent(group, () => preparedItems);
    }

    return CustomScrollbar(
      isScrollbarVisible: isScrollbarVisible,
      controller: controller,
      child: ListView.separated(
        controller: controller,
        itemCount: sortedItems.length,
        physics: isScrollEnabled
            ? OtherConstants.defaultScrollPhysics
            : NeverScrollableScrollPhysics(),
        scrollDirection: scrollDirection,
        shrinkWrap: shrinkWrap,
        reverse: isReversed,
        padding: padding,
        itemBuilder: (_, index) {
          final grouped = sortedItems.entries.toList()[index];
          if (groupCustomBuilder != null) {
            return groupCustomBuilder!(_, grouped.key, grouped.value, index);
          }

          return Column(
            children: [
              if (groupBuilder != null)
                groupBuilder!(_, grouped.key),
              for (int i = 0; i < grouped.value.length; i++) ...[
                if (itemBuilder != null)
                  itemBuilder!(_, grouped.value[i]),
                if (i + 1 < grouped.value.length && itemSeparatorBuilder != null)
                  itemSeparatorBuilder!(_, i),
              ],
            ],
          );
        },
        separatorBuilder: groupSeparatorBuilder ?? (_, index) {
          return SizedBox();
        },
      ),
    );
  }
}