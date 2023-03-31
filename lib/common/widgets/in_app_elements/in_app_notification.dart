import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../injection_container.dart';
import '../../bloc/core_bloc.dart';
import '../../models/in_app_notification_model.dart';
import '../../usecases/core_update_in_app_failure.dart';
import '../texts.dart';

class InAppNotificationBackground extends StatefulWidget {
  const InAppNotificationBackground({Key? key}) : super(key: key);

  static const showDuration = Duration(milliseconds: 300);
  static const successDuration = Duration(seconds: 4);
  static const warningDuration = Duration(seconds: 10);

  @override
  State<InAppNotificationBackground> createState() => _InAppNotificationBackgroundState();
}

class _InAppNotificationBackgroundState extends State<InAppNotificationBackground> {
  InAppNotificationData? _inAppNotification;
  bool _isShowing = false;

  Future<void> _onShowNotificationHandler(InAppNotificationData notification) async {
    if (_inAppNotification != null) {
      return;
    }

    setState(() {
      _inAppNotification = notification;
      _isShowing = true;
    });

    await Future.delayed(
      _inAppNotification?.type == InAppNotificationType.warning
          ? InAppNotificationBackground.warningDuration
          : InAppNotificationBackground.successDuration
    );
    await _onRemoveNotificationHandler(notification);
  }

  Future<void> _onRemoveNotificationHandler(InAppNotificationData? notification) async {
    if (notification != null && notification.id != _inAppNotification?.id) {
      return;
    }

    await _onHideNotificationHandler();
    setState(() {
      _inAppNotification = null;
    });

    await Future.delayed(const Duration(milliseconds: 50));
    locator<CoreUpdateInAppFailure>().call(null);
  }

  Future<void> _onReplaceNotificationHandler(InAppNotificationData notification) async {
    await _onHideNotificationHandler();
    setState(() {
      _inAppNotification = null;
    });

    await Future.delayed(const Duration(milliseconds: 50));
    _onShowNotificationHandler(notification);
  }

  Future<void> _onHideNotificationHandler() async {
    setState(() {
      _isShowing = false;
    });
    await Future.delayed(InAppNotificationBackground.showDuration);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CoreBloc, CoreState>(
      key: widget.key,
      listenWhen: (prev, current) {
        return prev.inAppNotificationData?.id != current.inAppNotificationData?.id;
      },
      listener: (_, state) {
        if ((state.inAppNotificationData == null || state.inAppNotificationData?.type == InAppNotificationType.none) && _inAppNotification == null) {
          return;
        }

        if ((state.inAppNotificationData == null || state.inAppNotificationData?.type == InAppNotificationType.none) && _inAppNotification != null) {
          _onRemoveNotificationHandler(null);
          return;
        }

        if (state.inAppNotificationData != null) {
          if (_inAppNotification == null) {
            _onShowNotificationHandler(state.inAppNotificationData!);
          } else {
            _onReplaceNotificationHandler(state.inAppNotificationData!);
          }
        }
      },
      child: GestureDetector(
        onTap: () => _onRemoveNotificationHandler(_inAppNotification),
        child: _NotificationBody(
          inAppNotification: _inAppNotification,
          isShowing: _isShowing,
        ),
      ),
    );
  }
}

class _NotificationBody extends StatelessWidget {
  final InAppNotificationData? inAppNotification;
  final bool isShowing;

  const _NotificationBody({
    Key? key,
    required this.inAppNotification,
    required this.isShowing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: InAppNotificationBackground.showDuration,
      opacity: isShowing ? 1.0 : 0.0,
      child: AnimatedContainer(
        duration: InAppNotificationBackground.showDuration,
        padding: const EdgeInsets.symmetric(
          vertical: 7.0,
          horizontal: 12.0,
        ),
        margin: EdgeInsets.only(
          top: isShowing ? 16.0 : 0.0,
          left: 40.0,
          right: 40.0,
        ),
        decoration: BoxDecoration(
          color: ColorConstants.light.red500.withOpacity(0.8),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        ),
        child: inAppNotification?.message != null
            ? Row(
                children: [
                  const SizedBox.square(
                    dimension: SizeConstants.defaultIconSize,
                    child: Icon(Icons.done),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Flexible(
                    child: SandboxText(
                      text: inAppNotification?.message ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 3,
                    ),
                  ),
                ],
              )
            : const SizedBox(),
      ),
    );
  }
}
