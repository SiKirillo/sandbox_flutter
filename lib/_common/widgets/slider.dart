part of '../common.dart';

class CustomSlider extends StatelessWidget {
  final double value, min, max;
  final int step;
  final SliderThemeData? theme;
  final CustomSliderType type;
  final ValueChanged<double> onChanged;

  const CustomSlider({
    super.key,
    required this.value,
    this.min = 0.0,
    this.max = 1.0,
    required this.step,
    this.theme,
    this.type = CustomSliderType.round,
    required this.onChanged,
  }) : assert(value >= 0.0 && min >= 0.0 && max >= 0.0);

  SliderThemeData _getThemeData(BuildContext context) {
    if (type == CustomSliderType.rectangle) {
      return SliderTheme.of(context).copyWith(
        activeTrackColor: ColorConstants.sliderTrackActive(),
        inactiveTrackColor: ColorConstants.sliderTrackDisable(),
        thumbColor: ColorConstants.sliderThumb(),
        overlayColor: ColorConstants.sliderOverlay(),
        trackHeight: 16.0,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0, pressedElevation: 0.0),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 12.0),
        tickMarkShape: SliderTickMarkShape.noTickMark,
      );
    }

    return SliderTheme.of(context).copyWith(
      activeTrackColor: ColorConstants.sliderTrackActive(),
      inactiveTrackColor: ColorConstants.sliderTrackDisable(),
      thumbColor: ColorConstants.sliderThumb(),
      overlayColor: ColorConstants.sliderOverlay(),
      trackHeight: 4.0,
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
      overlayShape: RoundSliderOverlayShape(overlayRadius: 12.0),
      tickMarkShape: SliderTickMarkShape.noTickMark,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double range = max - min;
    final bool divisible = (range % step).abs() < 1e-9;
    final int? divisionsCount = divisible ? (range / step).round() : null;

    return SliderTheme(
      data: theme ?? _getThemeData(context),
      child: Slider(
        value: value.clamp(min, max),
        min: min,
        max: max,
        divisions: divisionsCount,
        onChanged: (value) {
          final double stepped = (((value - min) / step).round() * step) + min;
          final double snapped = (stepped.clamp(min, max));
          onChanged(snapped);
        },
      ),
    );
  }
}

class CustomSliderDescription extends StatelessWidget {
  final int currentValue, min, max;
  final int maxSteps;
  final TextStyle? style;
  final Color? activeColor, disableColor;
  final bool withPercent;
  final CustomSliderType type;

  const CustomSliderDescription({
    super.key,
    required this.currentValue,
    required this.min,
    required this.max,
    this.maxSteps = 3,
    this.style,
    this.activeColor,
    this.disableColor,
    this.withPercent = false,
    this.type = CustomSliderType.round,
  }) : assert(min >= 0 && max >= 0 && maxSteps >= 0);

  double get width => math.max(
    '$min${withPercent ? '%' : ''}'.calculateSize(style: style).width + 2.0,
    '$max${withPercent ? '%' : ''}'.calculateSize(style: style).width + 2.0,
  );

  Widget _buildItemWidget(int value, BuildContext context) {
    return SizedBox(
      width: width,
      child: Center(
        child: AnimatedDefaultTextStyle(
          duration: OtherConstants.defaultAnimationDuration,
          style: style?.copyWith(
            color: value <= currentValue ? activeColor : disableColor,
          ) ?? Theme.of(context).textTheme.bodyMedium!,
          child: CustomText(
            text: '$value${withPercent ? '%' : ''}',
            maxLines: 1,
            isVerticalCentered: false,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final length = 2 + ((min + max).isOdd ? maxSteps - 1 : maxSteps);
    return Padding(
      padding: type == CustomSliderType.round
          ? EdgeInsets.symmetric(horizontal: 2.0)
          : EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(length, (index) {
          late final int value;
          if (index == 0) {
            value = min;
          } else if (index == length - 1) {
            value = max;
          } else {
            final step = (max - min) / (length - 1);
            value = min + (step * index).ceil();
          }

          return Flexible(
            child: _buildItemWidget(value, context),
          );
        }),
      ),
    );
  }
}

enum CustomSliderType {
  round,
  rectangle,
}
