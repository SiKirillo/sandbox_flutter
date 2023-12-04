import 'package:flutter/material.dart';
import 'package:sandbox_flutter/common/extensions/iterables.dart';
import 'package:sandbox_flutter/constants/colors.dart';

import 'tab_bar.dart';
import 'texts.dart';

/// You can only use string or widget in [CustomTabBarCustom].
class CustomTabBarCustom extends StatefulWidget {
  final List<dynamic> tabs;
  final Function(int) onSelect;
  final int initialIndex;
  final double height, tabsIntent;
  final EdgeInsets? padding;

  const CustomTabBarCustom({
    Key? key,
    required this.tabs,
    required this.onSelect,
    this.initialIndex = 0,
    this.height = 26.0,
    this.tabsIntent = 16.0,
    this.padding,
  })  : assert(tabs.length >= 1),
        assert(initialIndex >= 0 && initialIndex < tabs.length),
        assert(height >= 0 && tabsIntent >= 0),
        super(key: key);

  @override
  State<CustomTabBarCustom> createState() => _CustomTabBarCustomState();
}

class _CustomTabBarCustomState extends State<CustomTabBarCustom> {
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
  void didUpdateWidget(CustomTabBarCustom oldWidget) {
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
      startPosition += tabSizes[i];
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
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.tabsIntent * 0.5,
              ),
              child: _buildTabItem(
                tabContent,
                _selectedIndex == i,
              ),
            ),
          ),
        ),
      );
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
              top: 0.0,
              bottom: 0.0,
              left: _indicatorHorizontalPosition,
              width: _indicatorWidth,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  color: ColorConstants.transparent.withOpacity(0.6),
                ),
              ),
            ),
            SizedBox(
              key: _contentKey,
              height: widget.height,
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
