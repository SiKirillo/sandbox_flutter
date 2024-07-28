import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/in_app_failures/in_app_failure_provider.dart';
import '../app_bar.dart';

/// You can use this widget under the basic [Scaffold] to have more control
class ScaffoldWrapper extends StatelessWidget {
  final Widget child;
  final CustomAppBar? appBar;
  final Widget? navigationBar;
  final bool withSafeArea;
  final bool isDisabled;

  const ScaffoldWrapper({
    super.key,
    required this.child,
    this.appBar,
    this.navigationBar,
    this.withSafeArea = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: isDisabled || context.watch<InAppFailureProvider>().isShowing ? false : true,
      child: AbsorbPointer(
        absorbing: isDisabled,
        child: Scaffold(
          appBar: appBar,
          bottomNavigationBar: navigationBar,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            top: withSafeArea,
            child: child,
          ),
          resizeToAvoidBottomInset: false,
        ),
      ),
    );
  }
}
