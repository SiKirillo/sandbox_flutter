part of '../../common.dart';

class ContentWrapper extends StatelessWidget {
  final double navigationBarHeight;
  final EdgeInsets contentPadding;
  final List<SafeAreaType> safeArea;
  final bool withKeyboardResize;
  final Widget child;

  const ContentWrapper({
    super.key,
    this.contentPadding = EdgeInsets.zero,
    this.navigationBarHeight = 0.0,
    this.safeArea = const [SafeAreaType.top],
    this.withKeyboardResize = true,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final safeAreaInsets = safeArea.isContainsAtLeastOne([SafeAreaType.all, SafeAreaType.vertical, SafeAreaType.top])
        ? MediaQuery.viewPaddingOf(context).top
        : 0.0;
    final keyboardInsets = withKeyboardResize
        ? math.max(MediaQuery.viewInsetsOf(context).bottom - navigationBarHeight, 0.0)
        : 0.0;

    return Padding(
      padding: EdgeInsets.only(
        top: contentPadding.top + safeAreaInsets,
        bottom: contentPadding.bottom + keyboardInsets,
        left: contentPadding.left,
        right: contentPadding.right,
      ),
      child: child,
    );
  }
}