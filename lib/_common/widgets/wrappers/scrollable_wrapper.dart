part of '../../common.dart';

class ScrollableWrapper extends StatefulWidget {
  final ScrollController? controller;
  final CustomSliverAppBar? sliverAppBar;
  final SliverPersistentHeader? sliverPersistentHeader;
  final SliverRefreshIndicator? sliverRefreshIndicator;
  final ScrollableWrapperOptions options;
  final Widget child;

  const ScrollableWrapper({
    super.key,
    this.controller,
    this.sliverAppBar,
    this.sliverPersistentHeader,
    this.sliverRefreshIndicator,
    this.options = const ScrollableWrapperOptions(),
    required this.child,
  });

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
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback(_handleScrollStatus);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant ScrollableWrapper oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback(_handleScrollStatus);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeMetrics() {
    Future.delayed(OtherConstants.defaultDelayDuration).then((_) {
      _handleScrollStatus(null);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void reset() {
    _handleScrollStatus(null);
  }

  void _handleScrollStatus(void _) {
    if (widget.options.isAlwaysScrollable) return;
    final scrollerContext = _wrapperKey.currentContext;
    final contentContext = _contentKey.currentContext;
    final sliverAppBarHeight = widget.sliverAppBar?.flexibleSize ?? 0.0;

    if (scrollerContext == null || contentContext == null) {
      return;
    }

    final isNotEnoughSpace = (contentContext.size?.height ?? 0.0) + sliverAppBarHeight > (scrollerContext.size?.height ?? 0.0);
    if (mounted && _isScrollEnabled != isNotEnoughSpace) {
      setState(() {
        _isScrollEnabled = isNotEnoughSpace;
      });
    }
  }

  void _onListenScrollToRefreshHandler(void _) {
    final scrollZoneOffset = MediaQuery.sizeOf(context).height * 0.1;
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
      direction: widget.options.direction,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: widget.options.mainAxisAlignment,
      crossAxisAlignment: widget.options.crossAxisAlignment,
      children: <Widget>[
        SizedBox.square(dimension: widget.options.padding.top),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(
              left: widget.options.padding.left,
              right: widget.options.padding.right,
            ),
            child: widget.child,
          ),
        ),
        SizedBox.square(dimension: widget.options.padding.bottom),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isScrollEnabled = (widget.options.isScrollEnabled && _isScrollEnabled) || widget.options.isAlwaysScrollable;
    final isScrollListenerEnabled = isScrollEnabled && widget.sliverRefreshIndicator != null;

    if (widget.options.type == ScrollableWrapperType.dialog) {
      return RawScrollbar(
        controller: _scrollController,
        radius: Radius.circular(8.0),
        thickness: widget.options.isScrollbarVisible ? 4.0 : 0.0,
        thumbVisibility: widget.options.isScrollbarVisible,
        child: SingleChildScrollView(
          key: _wrapperKey,
          controller: _scrollController,
          scrollDirection: widget.options.direction,
          physics: isScrollEnabled
              ? OtherConstants.defaultScrollPhysics
              : NeverScrollableScrollPhysics(),
          reverse: widget.options.isReversed,
          child: _buildContentWidget(),
        ),
      );
    }

    return Listener(
      onPointerDown: isScrollListenerEnabled
          ? _onListenScrollToRefreshHandler
          : null,
      child: RawScrollbar(
        controller: _scrollController,
        radius: Radius.circular(8.0),
        thickness: widget.options.isScrollbarVisible ? 4.0 : 0.0,
        thumbVisibility: widget.options.isScrollbarVisible,
        child: CustomScrollView(
          key: _wrapperKey,
          controller: _scrollController,
          scrollDirection: widget.options.direction,
          physics: isScrollEnabled
              ? OtherConstants.defaultScrollPhysics
              : NeverScrollableScrollPhysics(),
          reverse: widget.options.isReversed,
          slivers: [
            if (widget.sliverAppBar != null) widget.sliverAppBar!,
            if (widget.sliverPersistentHeader != null) widget.sliverPersistentHeader!,
            if (widget.sliverRefreshIndicator != null && _isScrollToRefreshEnabled) widget.sliverRefreshIndicator!,
            widget.options.type == ScrollableWrapperType.expanded
                ? SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildContentWidget(),
                  )
                : SliverToBoxAdapter(
                    child: _buildContentWidget(),
                  ),
          ],
        ),
      ),
    );
  }
}

enum ScrollableWrapperType {
  expanded, /// fills all remaining space
  slim, /// fills minimum
  dialog, /// in bottom sheets
}

class ScrollableWrapperOptions {
  final ScrollableWrapperType type;
  final Axis direction;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsets padding;
  final bool isReversed;
  final bool isScrollEnabled;
  final bool isAlwaysScrollable;
  final bool isScrollbarVisible;

  const ScrollableWrapperOptions({
    this.type = ScrollableWrapperType.expanded,
    this.direction = Axis.vertical,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.padding = const EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 32.0),
    this.isReversed = false,
    this.isScrollEnabled = true,
    this.isAlwaysScrollable = false,
    this.isScrollbarVisible = false,
  });
}