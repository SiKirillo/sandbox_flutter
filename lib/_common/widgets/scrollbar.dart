part of '../common.dart';

class CustomScrollbar extends StatelessWidget {
  final bool isScrollbarVisible;
  final Widget child;
  final ScrollController? controller;

  const CustomScrollbar({
    super.key,
    this.isScrollbarVisible = false,
    required this.child,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return cupertino.CupertinoScrollbar(
      controller: controller,
      thickness: isScrollbarVisible ? 3.0 : 0.0,
      thicknessWhileDragging: isScrollbarVisible ? 8.0 : 0.0,
      child: child,
    );
  }
}
