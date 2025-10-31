part of '../../common.dart';

class ScaffoldWrapper extends StatelessWidget {
  final CustomAppBar? appBar;
  final Widget? navigationBar;
  final Widget? drawer, endDrawer;
  final Function(bool, dynamic)? onPopInvoked;
  final ScaffoldWrapperOptions options;
  final bool isDisabled;
  final Widget child;

  const ScaffoldWrapper({
    super.key,
    this.appBar,
    this.navigationBar,
    this.drawer,
    this.endDrawer,
    this.onPopInvoked,
    this.options = const ScaffoldWrapperOptions(),
    this.isDisabled = false,
    required this.child,
  });

  Widget _buildChildWrapper(BuildContext context) {
    final keyboardInsets = options.withKeyboardResize
        ? math.max(MediaQuery.viewInsetsOf(context).bottom - options.navigationBarHeight, 0.0)
        : 0.0;

    return Padding(
      padding: EdgeInsets.only(
        top: options.contentPadding.top,
        bottom: options.contentPadding.bottom + keyboardInsets,
        left: options.contentPadding.left,
        right: options.contentPadding.right,
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: options.isCanPop,
      onPopInvokedWithResult: onPopInvoked,
      child: AbsorbPointer(
        absorbing: isDisabled,
        child: Scaffold(
          appBar: appBar,
          drawer: drawer,
          endDrawer: endDrawer,
          bottomNavigationBar: navigationBar != null
              ? SafeArea(
                  bottom: options.safeArea.isContainsAtLeastOne([SafeAreaType.all, SafeAreaType.vertical, SafeAreaType.bottom]),
                  left: options.safeArea.isContainsAtLeastOne([SafeAreaType.all, SafeAreaType.horizontal, SafeAreaType.left]),
                  right: options.safeArea.isContainsAtLeastOne([SafeAreaType.all, SafeAreaType.horizontal, SafeAreaType.right]),
                  child: navigationBar!,
                )
              : null,
          body: SafeArea(
            top: options.safeArea.isContainsAtLeastOne([SafeAreaType.all, SafeAreaType.vertical, SafeAreaType.top]),
            left: options.safeArea.isContainsAtLeastOne([SafeAreaType.all, SafeAreaType.horizontal, SafeAreaType.left]),
            right: options.safeArea.isContainsAtLeastOne([SafeAreaType.all, SafeAreaType.horizontal, SafeAreaType.right]),
            child: _buildChildWrapper(context),
          ),
          backgroundColor: options.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
          drawerScrimColor: options.backgroundColor ?? Theme.of(context).drawerTheme.scrimColor,
          resizeToAvoidBottomInset: options.withBottomInsetResize,
          extendBodyBehindAppBar: options.extendBodyBehindAppBar,
        ),
      ),
    );
  }
}

class ScaffoldWrapperOptions {
  final double navigationBarHeight;
  final EdgeInsets contentPadding;
  final Color? backgroundColor, drawerScrimColor;
  final bool isCanPop;
  final List<SafeAreaType> safeArea;
  final bool withKeyboardResize;
  final bool withBottomInsetResize;
  final bool extendBodyBehindAppBar;

  const ScaffoldWrapperOptions({
    this.navigationBarHeight = 0.0,
    this.contentPadding = EdgeInsets.zero,
    this.backgroundColor,
    this.drawerScrimColor,
    this.isCanPop = true,
    this.safeArea = const [],
    this.withKeyboardResize = true,
    this.withBottomInsetResize = false,
    this.extendBodyBehindAppBar = false,
  });
}

enum SafeAreaType {
  all,
  vertical,
  horizontal,
  top,
  bottom,
  left,
  right,
}