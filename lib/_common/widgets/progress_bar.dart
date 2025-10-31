part of '../common.dart';

class CustomProgressBar extends StatelessWidget {
  final double ratio;
  final List<Color> gradientColors;
  final Color backgroundColor;

  const CustomProgressBar({
    super.key,
    required this.ratio,
    required this.gradientColors,
    required this.backgroundColor,
  });

  double get _ratio => math.min(ratio, 1.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        color: backgroundColor,
      ),
      child: LayoutBuilder(
        builder: (_, constraints) {
          final progressWidth = math.max(constraints.maxWidth * _ratio, 4.0);
          final isHaveMinSize = progressWidth > 4.0;

          return Row(
            children: [
              Container(
                width: progressWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  color: isHaveMinSize ? null : gradientColors.first,
                  gradient: isHaveMinSize ? LinearGradient(
                    colors: gradientColors,
                  ) : null,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
