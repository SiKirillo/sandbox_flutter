import 'dart:async';
import 'package:flutter/material.dart';

class CustomAutoScroll extends StatefulWidget {
  const CustomAutoScroll({
    super.key,
    required this.child,
    this.velocity = defaultVelocity,
    this.delayBefore = defaultPauseDuration,
    this.pauseBetween = defaultPauseDuration,
    this.pauseOnBounce = defaultPauseDuration,
  });

  static const defaultVelocity = Velocity(pixelsPerSecond: Offset(20, 0));
  static const defaultPauseDuration = Duration(milliseconds: 1000);

  /// The widget, that would be scrolled.
  /// In case widget does fit into allocated space, it wouldn't be scrolled
  /// and would be shown as is.
  final Widget child;

  /// Allows to customize animation speed.
  /// Default is `Velocity(pixelsPerSecond: Offset(20, 0))`
  final Velocity velocity;

  /// Delay before first animation round.
  /// Default is [Duration.zero].
  final Duration? delayBefore;

  /// Determines pause interval between animation rounds.
  /// Default is [Duration.zero].
  final Duration? pauseBetween;

  /// Determines pause interval before changing direction on a bounce.
  /// Default is [Duration.zero].
  final Duration? pauseOnBounce;

  @override
  State<CustomAutoScroll> createState() => _CustomAutoScrollState();
}

class _CustomAutoScrollState extends State<CustomAutoScroll> {
  final _scrollController = ScrollController();
  final _widgetKey = GlobalKey();
  double _widgetSize = 0.0;

  String? _endlessText;
  Timer? _timer;
  bool _running = false;

  bool get _available => mounted && _scrollController.hasClients;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleWidgetSize());
    WidgetsBinding.instance.addPostFrameCallback((_) => _initScroller());
  }

  @override
  void didUpdateWidget(covariant CustomAutoScroll oldWidget) {
    /// Update timer to adapt to changes in [widget.velocity]
    _setTimer();
    _onUpdate(oldWidget);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleWidgetSize();
    });

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _initScroller() async {
    await _delayBefore();
    _setTimer();
  }

  void _handleWidgetSize() {
    if (!mounted) return;

    final widgetContext = _widgetKey.currentContext;
    if (widgetContext == null) {
      return;
    }

    final oldSize = _widgetSize;
    final newSize = widgetContext.size!.height;

    if (mounted && oldSize != newSize) {
      setState(() {
        _widgetSize = newSize;
      });
    }
  }

  /// Sets [_timer] for animation
  void _setTimer() {
    /// Cancel previous timer if it exists
    _timer?.cancel();

    /// Reset [_running] to allow for updates on changed velocity
    _running = false;

    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!_available) {
        timer.cancel();
        return;
      }

      if (!_running) _run();
    });
  }

  Future<void> _run() async {
    _running = true;
    await _animateBouncing();
    _running = false;
  }

  Future<void> _animateBouncing() async {
    final maxExtent = _scrollController.position.maxScrollExtent;
    final minExtent = _scrollController.position.minScrollExtent;
    final extent = maxExtent - minExtent;
    final duration = _getDuration(extent);
    if (duration == Duration.zero) return;

    if (!_available) return;
    await _scrollController.animateTo(
      maxExtent,
      duration: duration,
      curve: Curves.linear,
    );

    if (widget.pauseOnBounce != null) {
      await Future.delayed(widget.pauseOnBounce!);
    }

    if (!_available) return;
    await _scrollController.animateTo(
      minExtent,
      duration: duration,
      curve: Curves.linear,
    );

    if (!_available) return;
    if (widget.pauseBetween != null) {
      await Future.delayed(widget.pauseBetween!);
    }
  }

  Future<void> _delayBefore() async {
    final delayBefore = widget.delayBefore;
    if (delayBefore == null) return;
    await Future.delayed(delayBefore);
  }

  Duration _getDuration(double extent) {
    /// No movement when velocity offset dx equals 0
    if (widget.velocity.pixelsPerSecond.dx == 0) return Duration.zero;

    final milliseconds = (extent * 1000 / widget.velocity.pixelsPerSecond.dx).round();
    return Duration(milliseconds: milliseconds);
  }

  void _onUpdate(CustomAutoScroll oldWidget) {
    if (widget.child != oldWidget.child && _endlessText != null) {
      setState(() {
        _endlessText = null;
      });

      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Container(
          key: _widgetKey,
          child: widget.child,
        ),
      ),
    );
  }
}
