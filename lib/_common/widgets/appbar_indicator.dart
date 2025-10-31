part of '../common.dart';

class CustomAppbarIndicator extends StatefulWidget {
  final int index;
  final int count;

  const CustomAppbarIndicator({
    super.key,
    this.index = 0,
    this.count = 1,
  })  : assert(index >= 0 && count >= 1),
        assert(count >= index);

  @override
  State<CustomAppbarIndicator> createState() => _CustomAppbarIndicatorState();
}

class _CustomAppbarIndicatorState extends State<CustomAppbarIndicator> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _animationController.value = widget.index / widget.count;
  }

  @override
  void didUpdateWidget(covariant CustomAppbarIndicator oldWidget) {
    if (widget.index != oldWidget.index || widget.count != oldWidget.count) {
      _onToggleExpansionHandler();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onToggleExpansionHandler() {
    final animationValue = widget.index / widget.count;
    _animationController.animateTo(animationValue, curve: Curves.easeInOut);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, child) {
        return SizedBox(
          height: 2.0,
          child: Stack(
            children: [
              Container(
                color: ColorConstants.appbarIndicatorDisable(),
              ),
              FractionallySizedBox(
                widthFactor: _animationController.value,
                child: Container(
                  color: ColorConstants.appbarIndicatorActive(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
