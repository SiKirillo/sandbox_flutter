part of '../common.dart';

class CustomScrollOpacityGradient extends StatelessWidget {
  final double size;
  final List<Color?> colors;
  final List<double> stops;
  final Axis direction;

  const CustomScrollOpacityGradient({
    super.key,
    required this.size,
    required this.colors,
    this.stops = const [0.05, 1.0],
    this.direction = Axis.vertical,
  }) : assert(size >= 0.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: direction == Axis.vertical ? size : null,
      width: direction == Axis.horizontal ? size : null,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: direction == Axis.vertical ? Alignment.topCenter : Alignment.centerLeft,
          end: direction == Axis.vertical ? Alignment.bottomCenter : Alignment.centerRight,
          colors: colors.map((color) => color ?? ColorConstants.transparent).toList(),
          stops: stops,
        ),
      ),
    );
  }
}
