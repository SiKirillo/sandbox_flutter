part of '../common.dart';

class DashNavigator extends StatefulWidget {
  final int number;
  final int total;

  const DashNavigator({
    super.key,
    required this.number,
    required this.total,
  });

  @override
  State<DashNavigator> createState() => _DashNavigatorState();
}

class _DashNavigatorState extends State<DashNavigator> {
  Widget _buildActivePoint() {
    return Container(
      height: 5.0,
      width: 16.0,
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      decoration: BoxDecoration(
        color: ColorConstants.dashActiveColor(isLight: context.watch<ThemeProvider>().isLight),
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      ),
    );
  }

  Widget _buildDisablePoint() {
    return Container(
      height: 5.0,
      width: 5.0,
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ColorConstants.dashDisableColor(isLight: context.watch<ThemeProvider>().isLight),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8.0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List<Widget>.generate(
          widget.total,
          (index) => widget.number == index ? _buildActivePoint() : _buildDisablePoint(),
        ),
      ),
    );
  }
}
