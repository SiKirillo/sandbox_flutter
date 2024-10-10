part of '../../common.dart';

class ScaffoldWrapper extends StatelessWidget {
  final CustomAppBar? appBar;
  final Widget? navigationBar;
  final Function(bool, dynamic)? onPopInvoked;
  final ScaffoldWrapperOptions options;
  final Widget child;

  const ScaffoldWrapper({
    super.key,
    this.appBar,
    this.navigationBar,
    this.onPopInvoked,
    this.options = const ScaffoldWrapperOptions(),
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: options.isCanPop,
      onPopInvokedWithResult: onPopInvoked,
      child: AbsorbPointer(
        absorbing: options.isDisabled,
        child: Scaffold(
          appBar: CustomAppBar.fromScaffold(
            appBar,
            context: context,
            isCanPop: options.isCanPop,
          ),
          bottomNavigationBar: navigationBar != null
              ? SafeArea(
                  bottom: options.withSafeArea,
                  child: navigationBar!,
                )
              : null,
          backgroundColor: options.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            top: options.withSafeArea,
            child: child,
          ),
          resizeToAvoidBottomInset: options.resizeToAvoidBottomInset,
        ),
      ),
    );
  }
}

class ScaffoldWrapperOptions {
  final bool withSafeArea;
  final bool isCanPop;
  final bool isDisabled;
  final bool resizeToAvoidBottomInset;
  final Color? backgroundColor;

  const ScaffoldWrapperOptions({
    this.withSafeArea = false,
    this.isCanPop = true,
    this.isDisabled = false,
    this.resizeToAvoidBottomInset = false,
    this.backgroundColor,
  });
}