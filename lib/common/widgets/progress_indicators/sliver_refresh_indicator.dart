import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show clampDouble;
import 'package:sandbox_flutter/common/widgets/wrappers/scrollable_wrapper.dart';

import 'progress_indicator.dart';

/// This is custom implementation of basic progress indicator in scrollable widgets
/// Based on [SandboxProgressIndicator] widget
/// To enable pull to refresh in [ScrollableWrapper] use this widget and select isAlwaysScrollable = true
class SliverRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final double size;

  const SliverRefreshIndicator({
    Key? key,
    required this.onRefresh,
    this.size = 30.0,
  })  : assert(size >= 0),
        super(key: key);

  final _kActivityIndicatorRadius = 14.0;
  final _kActivityIndicatorMargin = 16.0;

  Widget _buildIndicatorForRefreshState(
    RefreshIndicatorMode refreshState,
    double radius,
    double percentageComplete,
  ) {
    switch (refreshState) {
      case RefreshIndicatorMode.drag: {
        const scaleCurve = Interval(0.1, 0.5, curve: Curves.linear);
        const opacityCurve = Interval(0.2, 0.6, curve: Curves.linear);

        return Transform.scale(
          scale: scaleCurve.transform(percentageComplete),
          child: Opacity(
            opacity: opacityCurve.transform(percentageComplete),
            child: SandboxProgressIndicator(size: size),
          ),
        );
      }

      case RefreshIndicatorMode.armed:
      case RefreshIndicatorMode.refresh: {
        return SandboxProgressIndicator(size: size);
      }

      case RefreshIndicatorMode.done: {
        const scaleCurve = Interval(0.3, 0.7, curve: Curves.linear);
        const opacityCurve = Interval(0.3, 0.7, curve: Curves.linear);

        return Transform.scale(
          scale: scaleCurve.transform(percentageComplete),
          child: Opacity(
            opacity: opacityCurve.transform(percentageComplete),
            child: SandboxProgressIndicator(size: size),
          ),
        );
      }

      case RefreshIndicatorMode.inactive: {
        return Container();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverRefreshControl(
      onRefresh: onRefresh,
      builder: (_, refreshState, pulledExtent, refreshTriggerPullDistance, refreshIndicatorExtent) {
        final percentageComplete = clampDouble(pulledExtent / refreshTriggerPullDistance, 0.0, 1.0);
        final topPosition = _kActivityIndicatorMargin * 1.0;

        return Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Positioned(
                top: topPosition * percentageComplete,
                left: 0.0,
                right: 0.0,
                child: _buildIndicatorForRefreshState(
                  refreshState,
                  _kActivityIndicatorRadius,
                  percentageComplete,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
