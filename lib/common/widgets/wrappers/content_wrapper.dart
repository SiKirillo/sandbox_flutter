part of '../../common.dart';

class ContentWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final bool withSafeAreaResize;
  final bool withKeyboardResize;

  const ContentWrapper({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.withSafeAreaResize = true,
    this.withKeyboardResize = true,
  });

  @override
  Widget build(BuildContext context) {
    final safeAreaInsets = withSafeAreaResize
        ? MediaQuery.of(context).viewPadding.top
        : 0.0;
    final keyboardInsets = withKeyboardResize
        ? MediaQuery.of(context).viewInsets.bottom
        : 0.0;

    return Padding(
      padding: EdgeInsets.only(
        top: padding.top + safeAreaInsets,
        bottom: padding.bottom + keyboardInsets,
        left: padding.left,
        right: padding.right,
      ),
      child: child,
    );
  }
}
