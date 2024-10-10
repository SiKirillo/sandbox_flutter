// ignore_for_file: deprecated_member_use, unused_element

part of '../common.dart';

class CustomNavigationRail extends StatelessWidget {
  final List<NavigationBarData> items;
  final Function(int) onSelect;
  final int currentIndex;

  const CustomNavigationRail({
    super.key,
    required this.items,
    required this.onSelect,
    this.currentIndex = 0,
  })  : assert(items.length >= 1),
        assert(currentIndex >= 0);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
        width: SizeConstants.defaultNavigationBarSize,
        decoration: BoxDecoration(
          color: Theme.of(context).navigationBarTheme.backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
          boxShadow: [
            BoxShadow(
              color: ColorConstants.navigationBarShadowColor(),
              offset: const Offset(0.0, 10.0),
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.indexed.map((item) {
            return _NavigationRailItem(
              item: item.$2,
              onSelect: () => onSelect(item.$1),
              isSelected: currentIndex == item.$1,
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _NavigationRailItem extends StatefulWidget {
  final NavigationBarData item;
  final VoidCallback onSelect;
  final bool isSelected;

  const _NavigationRailItem({
    required this.item,
    required this.onSelect,
    required this.isSelected,
  });

  @override
  State<_NavigationRailItem> createState() => _NavigationRailItemState();
}

class _NavigationRailItemState extends State<_NavigationRailItem> with SingleTickerProviderStateMixin {
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
  void didUpdateWidget(covariant _NavigationRailItem oldWidget) {
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
            height: SizeConstants.defaultNavigationBarSize,
            width: SizeConstants.defaultNavigationBarSize,
            color: ColorConstants.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _NavigationRailIcon(
                  animation: ColorTween(
                    begin: ColorConstants.navigationBarDisableColor(),
                    end: ColorConstants.navigationBarActiveColor(),
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

class _NavigationRailIcon extends AnimatedWidget {
  final Animation<Color?> animation;
  final NavigationBarData item;
  final double size;

  const _NavigationRailIcon({
    required this.animation,
    required this.item,
    this.size = 24.0,
  }) : super(listenable: animation);

  Animation get _animation => listenable as Animation<Color?>;

  Widget _buildIconWidget() {
    if (item.icon is Image) {
      return Image(
        image: (item.icon as Image).image,
        color: _animation.value,
      );
    }

    if (item.icon is Icon) {
      return Icon(
        (item.icon as Icon).icon,
        color: _animation.value,
      );
    }

    if (item.icon is String) {
      if ((item.icon as String).contains(ImageConstants.svgPrefix)) {
        return SvgPicture.asset(
          item.icon,
          color: _animation.value,
        );
      } else {
        return Image.asset(
          item.icon,
          color: _animation.value,
        );
      }
    }

    return Image.asset(
      item.icon,
      color: _animation.value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: _buildIconWidget(),
    );
  }
}