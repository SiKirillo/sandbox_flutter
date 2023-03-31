import 'package:flutter/material.dart';
import 'package:sandbox_flutter/common/extensions/iterables.dart';

import 'texts.dart';

/// You can only use string or widget in [SandboxTabBar].
class SandboxTabBar extends StatefulWidget {
  final List<dynamic> tabs;
  final Function(int) onSelect;
  final int selected;
  final double height, padding;
  final double indicatorHeight, indicatorPadding;

  const SandboxTabBar({
    Key? key,
    required this.tabs,
    required this.onSelect,
    this.selected = 0,
    this.height = 26.0,
    this.padding = 16.0,
    this.indicatorHeight = 1.0,
    this.indicatorPadding = 4.0,
  })  : assert(tabs.length >= 1),
        assert(selected >= 0 && selected < tabs.length),
        assert(height >= 0 && padding >= 0),
        assert(indicatorHeight >= 0 && indicatorPadding >= 0),
        super(key: key);

  static const animationDuration = Duration(milliseconds: 200);

  @override
  State<SandboxTabBar> createState() => _SandboxTabBarState();
}

class _SandboxTabBarState extends State<SandboxTabBar> {
  late final _tabItemKeys = <GlobalKey>[];
  bool _isInit = false;

  double _indicatorHorizontalPosition = 0.0;
  double _indicatorWidth = 0.0;

  @override
  void initState() {
    super.initState();
    _tabItemKeys.addAll(widget.tabs.map((tab) => GlobalKey()));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateIndicatorPosition(widget.selected);
      Future.delayed(const Duration(milliseconds: 50)).then((_) {
        setState(() {
          _isInit = true;
        });
      });
    });
  }

  @override
  void didUpdateWidget(SandboxTabBar oldWidget) {
    if (widget.tabs.length > _tabItemKeys.length) {
      final delta = widget.tabs.length - _tabItemKeys.length;
      _tabItemKeys.addAll(List<GlobalKey>.generate(delta, (_) => GlobalKey()));
    } else if (widget.tabs.length < _tabItemKeys.length) {
      _tabItemKeys.removeRange(widget.tabs.length, _tabItemKeys.length);
    }

    super.didUpdateWidget(oldWidget);
  }

  void _onSelectTabHandler(int index) {
    if (widget.selected == index) {
      return;
    }

    widget.onSelect(index);
    _calculateIndicatorPosition(index);
  }

  void _calculateIndicatorPosition(int index) {
    final tabSizes = _tabItemKeys.map((key) {
      return key.currentContext?.size?.width ?? 0.0;
    }).toList();

    double startPosition = 0.0;
    for (int i = 0; i < index; i++) {
      startPosition += tabSizes[i] + widget.padding;
    }

    setState(() {
      _indicatorHorizontalPosition = startPosition;
      _indicatorWidth = tabSizes[index];
    });
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
            child: tabContent is Widget
                ? tabContent
                : AnimatedDefaultTextStyle(
                    duration: SandboxTabBar.animationDuration,
                    style: widget.selected == i
                        ? Theme.of(context).tabBarTheme.labelStyle!
                        : Theme.of(context).tabBarTheme.unselectedLabelStyle!,
                    child: SandboxText(
                      text: widget.tabs[i],
                    ),
                  ),
          ),
        ),
      );

      if (i + 1 < widget.tabs.length) {
        formattedTabs.add(SizedBox(width: widget.padding));
      }
    }

    return formattedTabs;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Stack(
          children: [
            SizedBox(
              height: widget.height - widget.indicatorPadding,
              child: Row(
                children: _buildTabsPanel(),
              ),
            ),
            AnimatedPositioned(
              duration: _isInit
                  ? SandboxTabBar.animationDuration
                  : Duration.zero,
              height: widget.indicatorHeight,
              bottom: 0.0,
              left: _indicatorHorizontalPosition,
              width: _indicatorWidth,
              child: Container(
                color: Theme.of(context).tabBarTheme.indicatorColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
