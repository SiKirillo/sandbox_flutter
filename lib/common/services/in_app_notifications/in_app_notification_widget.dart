part of 'in_app_notification_provider.dart';

class InAppNotificationBackground extends StatefulWidget {
  const InAppNotificationBackground({super.key});

  @override
  State<InAppNotificationBackground> createState() => _InAppNotificationBackgroundState();
}

class _InAppNotificationBackgroundState extends State<InAppNotificationBackground> {
  final _successDuration = const Duration(milliseconds: 4000);
  final _warningDuration = const Duration(milliseconds: 10000);
  final _delayDuration = const Duration(milliseconds: 50);

  final _inAppNotificationProvider = locator<InAppNotificationProvider>();
  InAppNotificationData? _inAppNotification;
  bool _isShowing = false;

  @override
  void initState() {
    super.initState();
    _inAppNotificationProvider.addListener(_onProviderListener);
  }

  @override
  void dispose() {
    _inAppNotificationProvider.addListener(_onProviderListener);
    super.dispose();
  }

  Future<void> _onProviderListener() async {
    final nextNotification = _inAppNotificationProvider.notification;
    if (_inAppNotification?.isSameNotification(nextNotification) == true) {
      return;
    }

    if (nextNotification == null && _inAppNotification == null) {
      return;
    }

    if (nextNotification?.isImportant == true && _inAppNotification != null) {
      _onRemoveNotificationHandler(_inAppNotification!);
      return;
    }

    if (nextNotification != null) {
      if (_inAppNotification == null) {
        _onShowNotificationHandler(nextNotification);
      } else {
        _onReplaceNotificationHandler(nextNotification);
      }
    }
  }

  Future<void> _onShowNotificationHandler(InAppNotificationData notification) async {
    if (_inAppNotification != null) {
      return;
    }

    if (mounted) {
      setState(() {
        _inAppNotification = notification;
        _isShowing = true;
      });
    }

    await Future.delayed(_inAppNotification?.type == InAppNotificationType.warning
        ? _warningDuration
        : _successDuration
    );
    await _onRemoveNotificationHandler(notification);
  }

  Future<void> _onRemoveNotificationHandler(InAppNotificationData notification) async {
    if (_inAppNotification?.isSameNotification(notification) != true) {
      return;
    }

    await _onHideNotificationHandler();
    if (mounted) {
      setState(() {
        _inAppNotification = null;
      });
    }

    await Future.delayed(_delayDuration);
    _inAppNotificationProvider.removeNotification(notification);
  }

  Future<void> _onReplaceNotificationHandler(InAppNotificationData inAppNotification) async {
    await _onHideNotificationHandler();
    if (mounted) {
      setState(() {
        _inAppNotification = null;
      });
    }

    await Future.delayed(_delayDuration);
    _onShowNotificationHandler(inAppNotification);
  }

  Future<void> _onHideNotificationHandler() async {
    if (mounted) {
      setState(() {
        _isShowing = false;
      });
    }

    await Future.delayed(StyleConstants.defaultAnimationDuration);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: widget.key,
      onTap: _inAppNotification != null
          ? () => _onRemoveNotificationHandler(_inAppNotification!)
          : null,
      child: Align(
        alignment: Alignment.topCenter,
        child: _InAppNotificationBody(
          notification: _inAppNotification,
          isShowing: _isShowing,
        ),
      ),
    );
  }
}

class _InAppNotificationBody extends StatelessWidget {
  final InAppNotificationData? notification;
  final bool isShowing;

  const _InAppNotificationBody({
    super.key,
    required this.notification,
    required this.isShowing,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: StyleConstants.defaultAnimationDuration,
      opacity: isShowing ? 1.0 : 0.0,
      child: AnimatedContainer(
        duration: StyleConstants.defaultAnimationDuration,
        padding: const EdgeInsets.symmetric(
          vertical: 7.0,
          horizontal: 12.0,
        ),
        margin: EdgeInsets.only(
          top: isShowing ? 16.0 : 0.0,
          left: 40.0,
          right: 40.0,
        ),
        decoration: const BoxDecoration(
          color: ColorConstants.transparent,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: notification?.message != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox.square(
                    dimension: SizeConstants.defaultIconSize,
                    child: Image.asset(ImageConstants.icClose),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Flexible(
                    child: CustomText(
                      text: notification?.message ?? '',
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
