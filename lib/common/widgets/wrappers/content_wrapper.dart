part of '../../common.dart';

class ContentWrapper extends StatelessWidget {
  final EdgeInsets padding;
  final bool withSafeAreaResize;
  final bool withKeyboardResize;
  final Widget child;

  const ContentWrapper({
    super.key,
    this.padding = EdgeInsets.zero,
    this.withSafeAreaResize = true,
    this.withKeyboardResize = true,
    required this.child,
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
