import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/core_bloc.dart';
import '../app_bar.dart';

/// You can use this widget under the basic [Scaffold] to have more control
class ScaffoldWrapper extends StatelessWidget {
  final Widget child;
  final CustomAppBar? appBar;
  final Widget? navigationBar;
  final bool withSafeArea;
  final bool isDisabled;

  const ScaffoldWrapper({
    Key? key,
    required this.child,
    this.appBar,
    this.navigationBar,
    this.withSafeArea = false,
    this.isDisabled = false,
  }) : super(key: key);

  Future<bool> _onWillPopCallback() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoreBloc, CoreState>(
      buildWhen: (prev, current) {
        return prev.inAppFailureData != current.inAppFailureData;
      },
      builder: (_, state) {
        return WillPopScope(
          onWillPop: isDisabled || state.inAppFailureData != null ? _onWillPopCallback : null,
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
      },
    );
  }
}
