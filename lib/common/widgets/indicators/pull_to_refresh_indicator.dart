// ignore_for_file: unused_element

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show clampDouble;

import 'progress_indicator.dart';

/// This is custom implementation of pull to refresh progress indicator
/// You must place this widget into some scrollable widget
/// Based on Android [RefreshIndicator] widget
class CustomPullToRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final double size;
  final Widget child;

  const CustomPullToRefreshIndicator({
    super.key,
    required this.onRefresh,
    this.size = 30.0,
    required this.child,
  })  : assert(size >= 0);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(
          overscroll: false,
          physics: const _DirectionalScrollPhysics(),
        ),
        child: _FootprintRefreshIndicator(
          displacement: 30.0,
          onRefresh: onRefresh,
          child: CustomScrollView(
            primary: true,
            shrinkWrap: true,
            clipBehavior: Clip.none,
            slivers: <Widget>[
              SliverFillRemaining(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

class _DirectionalScrollPhysics extends ScrollPhysics {
  final bool isInverted;

  const _DirectionalScrollPhysics({
    this.isInverted = false,
    super.parent = const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
  });

  @override
  _DirectionalScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _DirectionalScrollPhysics(
      isInverted: isInverted,
      parent: buildParent(ancestor),
    );
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    final condition = isInverted ? value < 0.0 : value > 0.0;
    return condition ? value : 0.0;
  }
}

enum _RefreshIndicatorMode {
  drag, /// Pointer is down.
  armed, /// Dragged far enough that an up event will run the onRefresh callback.
  snap, /// Animating to the indicator's final "displacement".
  refresh, /// Running the refresh callback.
  done, /// Animating the indicator's fade-out after refreshing.
  canceled, /// Animating the indicator's fade-out after not arming.
}

class _FootprintRefreshIndicator extends StatefulWidget {
  final RefreshCallback onRefresh;
  final double size;
  final double displacement, edgeOffset;
  final RefreshIndicatorTriggerMode triggerMode;
  final Widget child;

  const _FootprintRefreshIndicator({
    super.key,
    required this.onRefresh,
    this.size = 30.0,
    this.displacement = 40.0,
    this.edgeOffset = 0.0,
    this.triggerMode = RefreshIndicatorTriggerMode.onEdge,
    required this.child,
  });

  @override
  State<_FootprintRefreshIndicator> createState() => _FootprintRefreshIndicatorState();
}

class _FootprintRefreshIndicatorState extends State<_FootprintRefreshIndicator> with TickerProviderStateMixin<_FootprintRefreshIndicator> {
  late AnimationController _positionController;
  late AnimationController _scaleController;
  late Animation<double> _positionFactor;
  late Animation<double> _scaleFactor;
  late Animation<double> _value;
  late Animation<Color?> _valueColor;
  late Animation<double> _valueOpacity;

  _RefreshIndicatorMode? _mode;
  late Future<void> _pendingRefreshFuture;
  bool? _isIndicatorAtTop;
  double? _dragOffset;

  static const _kDragContainerExtentPercentage = 0.25;
  static const _kDragSizeFactorLimit = 1.5;
  static const _kIndicatorSnapDuration = Duration(milliseconds: 150);
  static const _kIndicatorScaleDuration = Duration(milliseconds: 200);

  static final Animatable<double> _threeQuarterTween = Tween<double>(begin: 0.0, end: 0.75);
  static final Animatable<double> _kDragSizeFactorLimitTween = Tween<double>(begin: 0.0, end: _kDragSizeFactorLimit);
  static final Animatable<double> _oneToZeroTween = Tween<double>(begin: 1.0, end: 0.0);

  @override
  void initState() {
    super.initState();
    _positionController = AnimationController(vsync: this);
    _positionFactor = _positionController.drive(_kDragSizeFactorLimitTween);
    _value = _positionController.drive(_threeQuarterTween);

    _scaleController = AnimationController(vsync: this);
    _scaleFactor = _scaleController.drive(_oneToZeroTween);

    _valueOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _positionController,
        curve: const Interval(0.15, 0.4, curve: Curves.linear),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    final theme = Theme.of(context);
    _valueColor = _positionController.drive(
      ColorTween(
        begin: (theme.colorScheme.primary).withOpacity(0.0),
        end: (theme.colorScheme.primary).withOpacity(1.0),
      ).chain(CurveTween(
        curve: const Interval(0.0, 1.0 / _kDragSizeFactorLimit),
      )),
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _positionController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  bool _shouldStart(ScrollNotification notification) {
    return ((notification is ScrollStartNotification && notification.dragDetails != null) ||
           (notification is ScrollUpdateNotification && notification.dragDetails != null && widget.triggerMode == RefreshIndicatorTriggerMode.anywhere)) &&
           ((notification.metrics.axisDirection == AxisDirection.up && notification.metrics.extentAfter == 0.0) ||
           (notification.metrics.axisDirection == AxisDirection.down && notification.metrics.extentBefore == 0.0)) && _mode == null && _start(notification.metrics.axisDirection);
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (!defaultScrollNotificationPredicate(notification)) {
      return false;
    }

    if (_shouldStart(notification)) {
      setState(() {
        _mode = _RefreshIndicatorMode.drag;
      });
      return false;
    }

    bool? indicatorAtTopNow;

    switch (notification.metrics.axisDirection) {
      case AxisDirection.down:
      case AxisDirection.up: {
        indicatorAtTopNow = true;
        break;
      }

      case AxisDirection.left:
      case AxisDirection.right: {
        indicatorAtTopNow = null;
        break;
      }
    }

    if (indicatorAtTopNow != _isIndicatorAtTop) {
      if (_mode == _RefreshIndicatorMode.drag || _mode == _RefreshIndicatorMode.armed) {
        _dismiss(_RefreshIndicatorMode.canceled);
      }
    } else if (notification is ScrollUpdateNotification) {
      if (_mode == _RefreshIndicatorMode.drag || _mode == _RefreshIndicatorMode.armed) {
        if ((notification.metrics.axisDirection == AxisDirection.down && notification.metrics.extentBefore > 0.0) ||
            (notification.metrics.axisDirection == AxisDirection.up && notification.metrics.extentAfter > 0.0)) {
          _dismiss(_RefreshIndicatorMode.canceled);
        } else {
          if (notification.metrics.axisDirection == AxisDirection.down) {
            _dragOffset = _dragOffset! - notification.scrollDelta!;
          } else if (notification.metrics.axisDirection == AxisDirection.up) {
            _dragOffset = _dragOffset! + notification.scrollDelta!;
          }
          _checkDragOffset(notification.metrics.viewportDimension);
        }
      }
      if (_mode == _RefreshIndicatorMode.armed && notification.dragDetails == null) {
        _show();
      }
    } else if (notification is OverscrollNotification) {
      if (_mode == _RefreshIndicatorMode.drag || _mode == _RefreshIndicatorMode.armed) {
        if (notification.metrics.axisDirection == AxisDirection.down) {
          _dragOffset = _dragOffset! - notification.overscroll;
        } else if (notification.metrics.axisDirection == AxisDirection.up) {
          _dragOffset = _dragOffset! + notification.overscroll;
        }
        _checkDragOffset(notification.metrics.viewportDimension);
      }
    } else if (notification is ScrollEndNotification) {
      switch (_mode) {
        case _RefreshIndicatorMode.armed: {
          _show();
          break;
        }

        case _RefreshIndicatorMode.drag: {
          _dismiss(_RefreshIndicatorMode.canceled);
          break;
        }

        case null:
          break;

        default:
      }
    }

    return false;
  }

  bool _handleIndicatorNotification(OverscrollIndicatorNotification notification) {
    if (notification.depth != 0 || !notification.leading) {
      return false;
    }

    if (_mode == _RefreshIndicatorMode.drag) {
      notification.disallowIndicator();
      return true;
    }

    return false;
  }

  bool _start(AxisDirection direction) {
    assert(_mode == null);
    assert(_isIndicatorAtTop == null);
    assert(_dragOffset == null);

    switch (direction) {
      case AxisDirection.down:
      case AxisDirection.up: {
        _isIndicatorAtTop = true;
        break;
      }

      case AxisDirection.left:
      case AxisDirection.right: {
        _isIndicatorAtTop = null;
        return false;
      }
    }

    _dragOffset = 0.0;
    _scaleController.value = 0.0;
    _positionController.value = 0.0;

    return true;
  }

  void _checkDragOffset(double containerExtent) {
    assert(_mode == _RefreshIndicatorMode.drag || _mode == _RefreshIndicatorMode.armed);
    double newValue = _dragOffset! / (containerExtent * _kDragContainerExtentPercentage);

    if (_mode == _RefreshIndicatorMode.armed) {
      newValue = math.max(newValue, 1.0 / _kDragSizeFactorLimit);
    }

    _positionController.value = clampDouble(newValue, 0.0, 1.0);
    if (_mode == _RefreshIndicatorMode.drag && _valueColor.value!.alpha == 0xFF) {
      _mode = _RefreshIndicatorMode.armed;
    }
  }

  Future<void> _dismiss(_RefreshIndicatorMode newMode) async {
    await Future<void>.value();
    assert(newMode == _RefreshIndicatorMode.canceled || newMode == _RefreshIndicatorMode.done);
    setState(() {
      _mode = newMode;
    });

    switch (_mode!) {
      case _RefreshIndicatorMode.done: {
        await _scaleController.animateTo(1.0, duration: _kIndicatorScaleDuration);
        break;
      }

      case _RefreshIndicatorMode.canceled: {
        await _positionController.animateTo(0.0, duration: _kIndicatorScaleDuration);
        break;
      }

      default:
        break;
    }

    if (mounted && _mode == newMode) {
      _dragOffset = null;
      _isIndicatorAtTop = null;
      setState(() {
        _mode = null;
      });
    }
  }

  void _show() {
    assert(_mode != _RefreshIndicatorMode.refresh);
    assert(_mode != _RefreshIndicatorMode.snap);

    final completer = Completer<void>();
    _pendingRefreshFuture = completer.future;
    _mode = _RefreshIndicatorMode.snap;
    _positionController.animateTo(1.0 / _kDragSizeFactorLimit, duration: _kIndicatorSnapDuration).then<void>((value) {
      if (mounted && _mode == _RefreshIndicatorMode.snap) {
        setState(() {
          _mode = _RefreshIndicatorMode.refresh;
        });

        final refreshResult = widget.onRefresh();
        refreshResult.whenComplete(() {
          if (mounted && _mode == _RefreshIndicatorMode.refresh) {
            completer.complete();
            _dismiss(_RefreshIndicatorMode.done);
          }
        });
      }
    });
  }

  Future<void> show({bool atTop = true}) {
    if (_mode != _RefreshIndicatorMode.refresh && _mode != _RefreshIndicatorMode.snap) {
      if (_mode == null) {
        _start(atTop ? AxisDirection.down : AxisDirection.up);
      }
      _show();
    }
    return _pendingRefreshFuture;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final child = NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: _handleIndicatorNotification,
        child: widget.child,
      ),
    );

    assert(() {
      if (_mode == null) {
        assert(_dragOffset == null);
        assert(_isIndicatorAtTop == null);
      } else {
        assert(_dragOffset != null);
        assert(_isIndicatorAtTop != null);
      }
      return true;
    } ());

    return Stack(
      children: <Widget>[
        child,
        if (_mode != null)
          Positioned(
            top: _isIndicatorAtTop! ? widget.edgeOffset : null,
            bottom: !_isIndicatorAtTop! ? widget.edgeOffset : null,
            left: 0.0,
            right: 0.0,
            child: SizeTransition(
              axisAlignment: _isIndicatorAtTop! ? 1.0 : -1.0,
              sizeFactor: _positionFactor,
              child: Container(
                padding: _isIndicatorAtTop!
                    ? EdgeInsets.only(top: widget.displacement)
                    : EdgeInsets.only(bottom: widget.displacement),
                alignment: _isIndicatorAtTop!
                    ? Alignment.topCenter
                    : Alignment.bottomCenter,
                child: ScaleTransition(
                  scale: _scaleFactor,
                  child: AnimatedBuilder(
                    animation: _valueOpacity,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _valueOpacity.value,
                        child: CustomProgressIndicator(size: widget.size),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
