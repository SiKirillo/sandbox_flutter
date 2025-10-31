part of '../common.dart';

class CustomNavigationBar extends StatelessWidget {
  final List<NavigationBarData> items;
  final Function(int) onSelect;
  final int currentIndex;
  final CustomNavigationBarType type;

  const CustomNavigationBar({
    super.key,
    required this.items,
    required this.onSelect,
    this.currentIndex = 0,
    this.type = CustomNavigationBarType.white,
  })  : assert(items.length >= 1),
        assert(currentIndex >= 0);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConstants.defaultNavigationBarSize + MediaQuery.viewPaddingOf(context).bottom,
      padding: EdgeInsets.only(bottom: MediaQuery.viewPaddingOf(context).bottom),
      decoration: BoxDecoration(
        color: ColorConstants.navigationBarBG(type),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
        boxShadow: [
          BoxShadow(
            color: ColorConstants.navigationBarShadow(),
            offset: Offset(0.0, 2.0),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
        child: Row(
          mainAxisAlignment:
              SizeConstants.isMobile(context: context) ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
          spacing: SizeConstants.isMobile(context: context) ? 0.0 : MediaQuery.sizeOf(context).width * 0.05,
          children: items.indexed.map((item) {
            return Stack(
              children: [
                _NavigationBarItem(
                  item: item.$2,
                  onSelect: () => onSelect(item.$1),
                  isSelected: currentIndex == item.$1,
                  type: type,
                ),
                if (item.$2.showNotificationPoint)
                  // Красный круг с белым текстом, если есть countNotifications > 0
                  Positioned(
                    top: 5,
                    right: 15,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: (item.$2.countNotifications != null && item.$2.countNotifications! > 0)
                          ? Text(
                              '${item.$2.countNotifications}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            )
                          : null,
                    ),
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

enum CustomNavigationBarType {
  white,
  blue,
}

class NavigationBarData {
  final String label;
  final dynamic icon;
  final bool showNotificationPoint;
  final int? countNotifications;

  const NavigationBarData({
    required this.label,
    required this.icon,
    this.showNotificationPoint = false,
    this.countNotifications,
  }) : assert(icon is String || icon is Icon || icon is Image);
}

class _NavigationBarItem extends StatefulWidget {
  final NavigationBarData item;
  final VoidCallback onSelect;
  final bool isSelected;
  final CustomNavigationBarType type;

  const _NavigationBarItem({
    required this.item,
    required this.onSelect,
    required this.isSelected,
    required this.type,
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
      duration: Duration(milliseconds: 300),
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
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width / 5.0,
              minWidth: 74.0,
            ),
            child: Container(
              color: ColorConstants.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _NavigationBarIcon(
                    animation: ColorTween(
                      begin: ColorConstants.navigationBarDisable(widget.type),
                      end: ColorConstants.navigationBarActive(widget.type),
                    ).animate(_animationController),
                    item: widget.item,
                  ),
                  SizedBox(height: 6.0),
                  _NavigationBarLabel(
                    animation: TextStyleTween(
                      begin: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w600,
                        height: 12.0 / 10.0,
                        color: ColorConstants.navigationBarDisable(widget.type),
                      ),
                      end: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w600,
                        height: 12.0 / 10.0,
                        color: ColorConstants.navigationBarActive(widget.type),
                      ),
                    ).animate(_animationController),
                    item: widget.item,
                  ),
                ],
              ),
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

class _NavigationBarLabel extends AnimatedWidget {
  final Animation<TextStyle?> animation;
  final NavigationBarData item;

  const _NavigationBarLabel({
    required this.animation,
    required this.item,
  }) : super(listenable: animation);

  Animation get _animation => listenable as Animation<TextStyle?>;

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: item.label,
      style: _animation.value,
    );
  }
}
