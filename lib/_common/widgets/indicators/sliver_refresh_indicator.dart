part of '../../common.dart';

class SliverRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final double size;

  const SliverRefreshIndicator({
    super.key,
    required this.onRefresh,
    this.size = 30.0,
  }) : assert(size >= 0);

  final _kActivityIndicatorRadius = 14.0;
  final _kActivityIndicatorMargin = 16.0;

  Widget _buildIndicatorForRefreshState(
    cupertino.RefreshIndicatorMode refreshState,
    double radius,
    double percentageComplete,
  ) {
    switch (refreshState) {
      case cupertino.RefreshIndicatorMode.drag: {
        const scaleCurve = Interval(0.1, 0.5, curve: Curves.linear);
        const opacityCurve = Interval(0.2, 0.6, curve: Curves.linear);

        return Transform.scale(
          scale: scaleCurve.transform(percentageComplete),
          child: Opacity(
            opacity: opacityCurve.transform(percentageComplete),
            child: CustomProgressIndicator(
              indicatorValue: percentageComplete,
            ),
          ),
        );
      }

      case cupertino.RefreshIndicatorMode.armed:
      case cupertino.RefreshIndicatorMode.refresh: {
        return CustomProgressIndicator();
      }

      case cupertino.RefreshIndicatorMode.done:
      case cupertino.RefreshIndicatorMode.inactive: {
        return Container();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return cupertino.CupertinoSliverRefreshControl(
      refreshTriggerPullDistance: 60.0,
      refreshIndicatorExtent: 40.0,
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
