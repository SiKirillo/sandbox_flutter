part of 'in_app_notification_provider.dart';

class InAppNotificationBuilder extends StatefulWidget {
  const InAppNotificationBuilder({super.key});

  @override
  State<InAppNotificationBuilder> createState() => _InAppNotificationBuilderState();
}

class _InAppNotificationBuilderState extends State<InAppNotificationBuilder> {
  final _successDuration = Duration(milliseconds: 4000);
  final _warningDuration = Duration(milliseconds: 10000);
  final _delayDuration = Duration(milliseconds: 50);

  final _provider = locator<InAppNotificationProvider>();
  InAppNotificationData? _inAppNotification;
  bool _isShowing = false;

  @override
  void initState() {
    super.initState();
    _provider.addListener(_onProviderListener);
  }

  @override
  void dispose() {
    _provider.removeListener(_onProviderListener);
    super.dispose();
  }

  Future<void> _onProviderListener() async {
    final nextNotification = _provider.notification;
    if (_inAppNotification?.isEqual(nextNotification) == true) {
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

    if (_inAppNotification?.type == InAppNotificationType.warning) {
      await Future.delayed(_warningDuration);
    } else {
      await Future.delayed(_successDuration);
    }

    await _onRemoveNotificationHandler(notification);
  }

  Future<void> _onRemoveNotificationHandler(InAppNotificationData notification) async {
    if (_inAppNotification?.isEqual(notification) != true) {
      return;
    }

    await _onHideNotificationHandler();
    if (mounted) {
      setState(() {
        _inAppNotification = null;
      });
    }

    await Future.delayed(_delayDuration);
    _provider.removeNotification(notification);
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

    await Future.delayed(OtherConstants.defaultAnimationDuration);
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
        child: _InAppNotificationWidget(
          notification: _inAppNotification,
          isShowing: _isShowing,
        ),
      ),
    );
  }
}

class _InAppNotificationWidget extends StatelessWidget {
  final InAppNotificationData? notification;
  final bool isShowing;

  const _InAppNotificationWidget({
    required this.notification,
    required this.isShowing,
  });

  Widget _buildMessageWidget(BuildContext context) {
    if (notification?.message is String) {
      return CustomText(
        text: notification?.message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: ColorConstants.inAppNotificationText(),
        ),
        overflow: TextOverflow.clip,
        maxLines: 3,
        textWidthBasis: TextWidthBasis.longestLine,
        isVerticalCentered: false,
      );
    }

    return notification?.message ?? SizedBox();
  }

  Widget _buildNotificationWidget(BuildContext context) {
    if (notification?.message == null) {
      return SizedBox();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (notification?.type == InAppNotificationType.success)
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: SvgPicture.asset(
              ImageConstants.icSuccess,
              height: 20.0,
              width: 20.0,
            ),
          ),
        if (notification?.type == InAppNotificationType.warning)
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: SvgPicture.asset(
              ImageConstants.icError,
              height: 20.0,
              width: 20.0,
            ),
          ),
        Flexible(
          child: _buildMessageWidget(context),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: OtherConstants.defaultAnimationDuration,
      opacity: isShowing ? 1.0 : 0.0,
      child: AnimatedContainer(
        duration: OtherConstants.defaultAnimationDuration,
        constraints: BoxConstraints(
          minHeight: 44.0,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 16.0,
        ),
        margin: EdgeInsets.only(
          top: isShowing ? 16.0 : 0.0,
          left: 24.0,
          right: 24.0,
        ),
        decoration: BoxDecoration(
          color: ColorConstants.inAppNotificationBG(),
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        child: _buildNotificationWidget(context),
      ),
    );
  }
}
