part of '../common.dart';

class CustomTabBar extends StatefulWidget {
  final List<dynamic> tabs;
  final Function(int) onSelect;
  final int initialIndex;
  final double height, tabsIntent;
  final double indicatorHeight, indicatorPadding;
  final EdgeInsets? padding;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.onSelect,
    this.initialIndex = 0,
    this.height = 26.0,
    this.tabsIntent = 16.0,
    this.indicatorHeight = 1.0,
    this.indicatorPadding = 4.0,
    this.padding,
  })  : assert(tabs.length >= 1),
        assert(initialIndex >= 0 && initialIndex < tabs.length),
        assert(height >= 0 && tabsIntent >= 0),
        assert(indicatorHeight >= 0 && indicatorPadding >= 0);

  static const animationDuration = Duration(milliseconds: 200);

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  final _wrapperKey = GlobalKey();
  final _contentKey = GlobalKey();

  late final _tabItemKeys = <GlobalKey>[];
  late int _selectedIndex;

  bool _isInit = false;
  bool _isScrollEnabled = false;

  double _indicatorHorizontalPosition = 0.0;
  double _indicatorWidth = 0.0;

  @override
  void initState() {
    super.initState();
    _tabItemKeys.addAll(widget.tabs.map((tab) => GlobalKey()));
    _selectedIndex = widget.initialIndex;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateIndicatorPosition(_selectedIndex);
      Future.delayed(const Duration(milliseconds: 50)).then((_) {
        setState(() {
          _isInit = true;
        });
      });
    });
  }

  @override
  void didUpdateWidget(CustomTabBar oldWidget) {
    if (widget.tabs.length > _tabItemKeys.length) {
      final delta = widget.tabs.length - _tabItemKeys.length;
      _tabItemKeys.addAll(List<GlobalKey>.generate(delta, (_) => GlobalKey()));
    } else if (widget.tabs.length < _tabItemKeys.length) {
      _tabItemKeys.removeRange(widget.tabs.length, _tabItemKeys.length);
    }

    WidgetsBinding.instance.addPostFrameCallback(_handleScrollStatus);
    super.didUpdateWidget(oldWidget);
  }

  void _onSelectTabHandler(int index) {
    if (_selectedIndex == index) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    widget.onSelect(_selectedIndex);
    _calculateIndicatorPosition(_selectedIndex);
  }

  void _calculateIndicatorPosition(int index) {
    final tabSizes = _tabItemKeys.map((key) {
      return key.currentContext?.size?.width ?? 0.0;
    }).toList();

    double startPosition = 0.0;
    for (int i = 0; i < index; i++) {
      startPosition += tabSizes[i] + widget.tabsIntent;
    }

    setState(() {
      _indicatorHorizontalPosition = startPosition;
      _indicatorWidth = tabSizes[index];
    });
  }

  void _handleScrollStatus(_) {
    final scrollerContext = _wrapperKey.currentContext;
    final contentContext = _contentKey.currentContext;

    if (scrollerContext == null || contentContext == null) {
      return;
    }

    final isNotEnoughSpace = contentContext.size!.width > scrollerContext.size!.width;
    if (mounted && _isScrollEnabled != isNotEnoughSpace) {
      setState(() {
        _isScrollEnabled = isNotEnoughSpace;
      });
    }
  }

  List<Widget> _buildTabsPanel() {
    assert(widget.tabs.isContainsOnlyOneType(String) || widget.tabs.isContainsOnlyOneType(Widget));
    final formattedTabs = <Widget>[];

    for (int i = 0; i < widget.tabs.length; i++) {
      final tabContent = widget.tabs[i];
      formattedTabs.add(
        KeyedSubtree(
          key: _tabItemKeys[i],
          child: GestureDetector(
            onTap: () => _onSelectTabHandler(i),
            child: _buildTabItem(
              tabContent,
              _selectedIndex == i,
            ),
          ),
        ),
      );

      if (i + 1 < widget.tabs.length) {
        formattedTabs.add(SizedBox(width: widget.tabsIntent));
      }
    }

    return formattedTabs;
  }

  Widget _buildTabItem(dynamic tab, bool isSelected) {
    if (tab is Widget) {
      return tab;
    }

    return AnimatedDefaultTextStyle(
      duration: CustomTabBar.animationDuration,
      style: isSelected
          ? Theme.of(context).tabBarTheme.labelStyle!
          : Theme.of(context).tabBarTheme.unselectedLabelStyle!,
      child: CustomText(
        text: tab,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: SingleChildScrollView(
        key: _wrapperKey,
        scrollDirection: Axis.horizontal,
        padding: widget.padding,
        physics: _isScrollEnabled
            ? const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics())
            : const NeverScrollableScrollPhysics(),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: _isInit ? CustomTabBar.animationDuration : Duration.zero,
              height: widget.indicatorHeight,
              bottom: 0.0,
              left: _indicatorHorizontalPosition,
              width: _indicatorWidth,
              child: Container(
                color: Theme.of(context).tabBarTheme.indicatorColor,
              ),
            ),
            SizedBox(
              key: _contentKey,
              height: widget.height - widget.indicatorPadding,
              child: Row(
                children: _buildTabsPanel(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
