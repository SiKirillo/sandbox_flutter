import 'package:flutter/material.dart';

import '../../../constants/sizes.dart';
import '../app_bar.dart';
import '../indicators/sliver_refresh_indicator.dart';

enum ScrollableWrapperType {
  expanded, /// fills all remaining space
  slim, /// fills minimum
  dialog, /// in bottom sheets
}

/// You can use this widget under the basic [Scrollable] or [ListView] to have more control
/// If you have something like animated widgets (size), call setState on the parent class after the animation is complete
class ScrollableWrapper extends StatefulWidget {
  final ScrollController? controller;
  final Widget child;
  final CustomSliverAppBar? sliverAppBar;
  final SliverRefreshIndicator? sliverRefreshIndicator;
  final ScrollableWrapperType type;
  final Axis direction;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsets padding;
  final bool isScrollEnabled;
  final bool isAlwaysScrollable;

  const ScrollableWrapper({
    super.key,
    this.controller,
    required this.child,
    this.sliverAppBar,
    this.sliverRefreshIndicator,
    this.type = ScrollableWrapperType.expanded,
    this.direction = Axis.vertical,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.padding = ScrollableWrapper.defaultPadding,
    this.isScrollEnabled = true,
    this.isAlwaysScrollable = false,
  });

  static const defaultPadding = EdgeInsets.symmetric(
    vertical: SizeConstants.defaultPadding,
  );

  @override
  State<ScrollableWrapper> createState() => _ScrollableWrapperState();
}

class _ScrollableWrapperState extends State<ScrollableWrapper> with WidgetsBindingObserver {
  late final ScrollController _scrollController;
  final _wrapperKey = GlobalKey();
  final _contentKey = GlobalKey();

  bool _isScrollEnabled = false;
  bool _isScrollToRefreshEnabled = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback(_handleScrollStatus);
    _scrollController = widget.controller ?? ScrollController();
  }

  @override
  void didUpdateWidget(covariant ScrollableWrapper oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback(_handleScrollStatus);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeMetrics() {
    _handleScrollStatus(null);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _handleScrollStatus(_) {
    final scrollerContext = _wrapperKey.currentContext;
    final contentContext = _contentKey.currentContext;
    final sliverAppBarHeight = widget.sliverAppBar?.flexibleSize ?? 0.0;

    if (scrollerContext == null || contentContext == null) {
      return;
    }

    final isNotEnoughSpace = contentContext.size!.height + sliverAppBarHeight > scrollerContext.size!.height;
    if (mounted && _isScrollEnabled != isNotEnoughSpace) {
      setState(() {
        _isScrollEnabled = isNotEnoughSpace;
      });
    }
  }

  void _onListenScrollToRefreshHandler(_) {
    final scrollZoneOffset = MediaQuery.of(context).size.height * 0.1;
    if (_scrollController.offset <= scrollZoneOffset && _isScrollToRefreshEnabled != true) {
      setState(() {
        _isScrollToRefreshEnabled = true;
      });
      return;
    }

    if (_scrollController.offset > scrollZoneOffset && _isScrollToRefreshEnabled != false) {
      setState(() {
        _isScrollToRefreshEnabled = false;
      });
      return;
    }
  }

  Widget _buildContentWidget() {
    return Flex(
      key: _contentKey,
      direction: widget.direction,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: widget.mainAxisAlignment,
      crossAxisAlignment: widget.crossAxisAlignment,
      children: <Widget>[
        SizedBox.square(
          dimension: widget.padding.top,
        ),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(
              left: widget.padding.left,
              right: widget.padding.right,
            ),
            child: widget.child,
          ),
        ),
        SizedBox.square(
          dimension: widget.padding.bottom,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isScrollEnabled = (widget.isScrollEnabled && _isScrollEnabled) || widget.isAlwaysScrollable;
    final isScrollListenerEnabled = isScrollEnabled && widget.sliverRefreshIndicator != null;

    if (widget.type == ScrollableWrapperType.dialog) {
      return SingleChildScrollView(
        key: _wrapperKey,
        controller: _scrollController,
        scrollDirection: widget.direction,
        physics: isScrollEnabled
            ? const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics())
            : const NeverScrollableScrollPhysics(),
        child: _buildContentWidget(),
      );
    }

    return Listener(
      onPointerDown: isScrollListenerEnabled
          ? _onListenScrollToRefreshHandler
          : null,
      child: CustomScrollView(
        key: _wrapperKey,
        controller: _scrollController,
        scrollDirection: widget.direction,
        physics: isScrollEnabled
            ? const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics())
            : const NeverScrollableScrollPhysics(),
        slivers: [
          if (widget.sliverAppBar != null) widget.sliverAppBar!,
          if (widget.sliverRefreshIndicator != null && _isScrollToRefreshEnabled) widget.sliverRefreshIndicator!,
          widget.type == ScrollableWrapperType.expanded
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildContentWidget(),
                )
              : SliverToBoxAdapter(
                  child: _buildContentWidget(),
                ),
        ],
      ),
    );
  }
}
