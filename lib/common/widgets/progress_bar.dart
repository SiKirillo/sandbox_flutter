part of '../common.dart';

class CustomProgressBar extends StatefulWidget {
  final double ratio;

  const CustomProgressBar({
    super.key,
    required this.ratio,
  }) : assert(ratio >= 0.0);

  @override
  State<CustomProgressBar> createState() => _CustomProgressBarState();
}

class _CustomProgressBarState extends State<CustomProgressBar> {
  double get _ratio => math.min(widget.ratio, 1.0);

  // List<double> _getGradientStops() {
  //   if (_ratio < 0.5) {
  //     return [0.1, 0.9];
  //   } else if (_ratio < 1.0) {
  //     return [0.1, (0.5 / _ratio) - 0.1, 0.9];
  //   } else {
  //     return [0.1, 0.5, 0.9];
  //   }
  // }

  // List<Color> _getGradientColors() {
  //   if (_ratio < 0.5) {
  //     return [
  //       ColorConstants.progressBarGradient()[0],
  //       Color.lerp(ColorConstants.progressBarGradient()[0], ColorConstants.progressBarGradient()[1], _ratio + 0.5) ?? ColorConstants.transparent,
  //     ];
  //   } else if (_ratio < 1.0) {
  //     return [
  //       ColorConstants.progressBarGradient()[0],
  //       ColorConstants.progressBarGradient()[1],
  //       Color.lerp(ColorConstants.progressBarGradient()[1], ColorConstants.progressBarGradient()[2], _ratio) ?? ColorConstants.transparent,
  //     ];
  //   } else {
  //     return ColorConstants.progressBarGradient();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        color: ColorConstants.progressBarDisableColor(),
      ),
      child: LayoutBuilder(
        builder: (_, constraints) {
          final progressWidth = constraints.maxWidth * _ratio;
          final isHaveMinSize = progressWidth > 4.0;

          return Row(
            children: [
              Container(
                width: isHaveMinSize ? progressWidth : 4.0,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  color: isHaveMinSize ? null : ColorConstants.progressBarActiveColor(),
                  // gradient: isHaveMinSize
                  //     ? LinearGradient(
                  //         colors: progressGradientColors,
                  //         stops: widget.withCustomGradient
                  //             ? _getGradientStops()
                  //             : null,
                  //       )
                  //     : null,
                  boxShadow: [
                    BoxShadow(
                      color: ColorConstants.progressBarActiveColor().withOpacity(0.2),
                      offset: const Offset(0.0, 2.0),
                      blurRadius: 4.0,
                      spreadRadius: 0.0,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
