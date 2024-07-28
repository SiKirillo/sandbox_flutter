import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';
import '../providers/theme_provider.dart';
import 'texts.dart';

class NavigationBarData {
  final String label;
  final dynamic icon;
  final int index;

  const NavigationBarData({
    required this.label,
    required this.icon,
    required this.index,
  })  : assert(icon is String || icon is Icon || icon is Image),
        assert(index >= 0);
}

class CustomNavigationBar extends StatelessWidget {
  final List<NavigationBarData> items;
  final Function(int) onSelect;
  final int selected;

  const CustomNavigationBar({
    super.key,
    required this.items,
    required this.onSelect,
    this.selected = 0,
  })  : assert(items.length >= 1),
        assert(selected >= 0);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConstants.defaultNavigationBarSize,
      decoration: BoxDecoration(
        color: Theme.of(context).navigationBarTheme.backgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.map((item) {
          return _NavigationBarItem(
            item: item,
            onSelect: () => onSelect(item.index),
            isSelected: selected == item.index,
          );
        }).toList(),
      ),
    );
  }
}

class _NavigationBarItem extends StatefulWidget {
  final NavigationBarData item;
  final VoidCallback onSelect;
  final bool isSelected;

  const _NavigationBarItem({
    super.key,
    required this.item,
    required this.onSelect,
    required this.isSelected,
  });

  @override
  State<_NavigationBarItem> createState() => _NavigationBarItemState();
}

class _NavigationBarItemState extends State<_NavigationBarItem> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    if (widget.isSelected) {
      _animationController.forward(from: 1.0);
    }
  }

  @override
  void didUpdateWidget(covariant _NavigationBarItem oldWidget) {
    if (widget.isSelected) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, child) {
        return GestureDetector(
          onTap: widget.onSelect,
          child: Container(
            width: 74.0,
            padding: const EdgeInsets.symmetric(
              vertical: 6.0,
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NavigationBarIcon(
                  animation: ColorTween(
                    begin: context.watch<ThemeProvider>().isDark
                        ? ColorConstants.transparent
                        : ColorConstants.transparent,
                    end: ColorConstants.transparent,
                  ).animate(_animationController),
                  item: widget.item,
                  size: 24.0 + (_animationController.value * 4.0),
                ),
                _NavigationBarLabel(
                  animation: TextStyleTween(
                    begin: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      height: 14.0 / 12.0,
                      color: context.watch<ThemeProvider>().isDark
                          ? ColorConstants.transparent
                          : ColorConstants.transparent,
                    ),
                    end: const TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                      height: 14.0 / 13.0,
                      color: ColorConstants.transparent,
                    ),
                  ).animate(_animationController),
                  item: widget.item,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NavigationBarIcon extends AnimatedWidget {
  final Animation<Color?> animation;
  final NavigationBarData item;
  final double size;

  const _NavigationBarIcon({
    super.key,
    required this.animation,
    required this.item,
    required this.size,
  }) : super(listenable: animation);

  Animation get _animation => listenable as Animation<Color?>;

  Widget _buildIconWidget() {
    if (item.icon is Image) {
      return Image(
        image: (item.icon as Image).image,
        height: size,
        width: size,
        color: _animation.value,
      );
    }

    if (item.icon is Icon) {
      return Icon(
        (item.icon as Icon).icon,
        size: size,
        color: _animation.value,
      );
    }

    return Image.asset(
      item.icon,
      height: size,
      width: size,
      color: _animation.value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 28.0,
      child: _buildIconWidget(),
    );
  }
}

class _NavigationBarLabel extends AnimatedWidget {
  final Animation<TextStyle?> animation;
  final NavigationBarData item;

  const _NavigationBarLabel({
    super.key,
    required this.animation,
    required this.item,
  }) : super(listenable: animation);

  Animation get _animation => listenable as Animation<TextStyle?>;

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: item.label,
      style: _animation.value,
      isVerticalCentered: false,
    );
  }
}
