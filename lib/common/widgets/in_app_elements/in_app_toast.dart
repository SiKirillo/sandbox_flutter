import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/colors.dart';
import '../../../injection_container.dart';
import '../../bloc/core_bloc.dart';
import '../../models/in_app_toast_model.dart';
import '../../usecases/core_update_in_app_toast.dart';
import '../texts.dart';

class InAppToastBackground extends StatefulWidget {
  const InAppToastBackground({
    required ValueKey? key
  }) : super(key: key);

  static const showDuration = Duration(milliseconds: 300);

  @override
  State<InAppToastBackground> createState() => _InAppToastBackgroundState();
}

class _InAppToastBackgroundState extends State<InAppToastBackground> {
  InAppToastData? _inAppToast;
  bool _isShowing = false;

  Future<void> _onShowMessageHandler(InAppToastData toast) async {
    if (_inAppToast != null) {
      return;
    }

    setState(() {
      _inAppToast = toast;
      _isShowing = true;
    });
  }

  Future<void> _onRemoveMessageHandler(InAppToastData? toast) async {
    if (toast != null && toast.id != _inAppToast?.id) {
      return;
    }

    await _onHideMessageHandler();
    setState(() {
      toast = null;
    });

    await Future.delayed(const Duration(milliseconds: 50));
    locator<CoreUpdateInAppToast>().call(null);
  }

  Future<void> _onReplaceMessageHandler(InAppToastData toast) async {
    await _onHideMessageHandler();
    setState(() {
      _inAppToast = null;
    });

    await Future.delayed(const Duration(milliseconds: 50));
    _onShowMessageHandler(toast);
  }

  Future<void> _onHideMessageHandler() async {
    setState(() {
      _isShowing = false;
    });
    await Future.delayed(InAppToastBackground.showDuration);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CoreBloc, CoreState>(
      key: widget.key,
      listenWhen: (prev, current) {
        return prev.infoToastData?.id != current.infoToastData?.id;
      },
      listener: (_, state) {
        if (state.infoToastData != null && widget.key != state.infoToastData?.key ) {
          return;
        }

        if (state.infoToastData == null && _inAppToast == null) {
          return;
        }

        if (state.infoToastData == null && _inAppToast != null) {
          _onRemoveMessageHandler(null);
          return;
        }

        if (state.infoToastData != null) {
          if (_inAppToast == null) {
            _onShowMessageHandler(state.infoToastData!);
          } else {
            _onReplaceMessageHandler(state.infoToastData!);
          }
        }
      },
      child: GestureDetector(
        onTap: () => _onRemoveMessageHandler(_inAppToast),
        child: _InfoMessage(
          inAppToast: _inAppToast,
          isShowing: _isShowing,
        ),
      ),
    );
  }
}

class _InfoMessage extends StatefulWidget {
  final InAppToastData? inAppToast;
  final bool isShowing;

  const _InfoMessage({
    Key? key,
    required this.inAppToast,
    required this.isShowing,
  }) : super(key: key);

  @override
  State<_InfoMessage> createState() => _InfoMessageState();
}

class _InfoMessageState extends State<_InfoMessage> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animatedOpacityContainer;
  late final Animation<double> _animatedOpacityText;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: InAppToastBackground.showDuration,
    );

    _animatedOpacityContainer = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 1.0, curve: Curves.ease),
      ),
    );
    _animatedOpacityText = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 1.0, curve: Curves.ease),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant _InfoMessage oldWidget) {
    if (widget.isShowing && !oldWidget.isShowing) {
      _animationController.forward();
    }

    if (!widget.isShowing && oldWidget.isShowing) {
      _animationController.reverse();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, child) {
        return Container(
          padding: EdgeInsets.symmetric(
            vertical: 10.0 * _animatedOpacityContainer.value,
            horizontal: 12.0,
          ),
          margin: EdgeInsets.only(
            top: 16.0 * _animatedOpacityContainer.value,
          ),
          decoration: BoxDecoration(
            color: ColorConstants.light.red500.withOpacity(0.2 * _animatedOpacityContainer.value),
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            heightFactor: _animatedOpacityContainer.value,
            child: widget.inAppToast?.message != null
                ? SandboxText(
                    text: widget.inAppToast?.message ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: ColorConstants.light.red500.withOpacity(_animatedOpacityText.value),
                      height: 16.0 / 14.0,
                    ),
                    maxLines: 3,
                  )
                : const SizedBox(),
          ),
        );
      }
    );
  }
}
