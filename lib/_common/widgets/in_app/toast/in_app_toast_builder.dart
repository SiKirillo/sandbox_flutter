part of 'in_app_toast_provider.dart';

class InAppToastBuilder extends StatefulWidget {
  const InAppToastBuilder({
    required super.key,
  });

  @override
  State<InAppToastBuilder> createState() => _InAppToastBuilderState();
}

class _InAppToastBuilderState extends State<InAppToastBuilder> {
  final _delayDuration = Duration(milliseconds: 50);

  final _provider = locator<InAppToastProvider>();
  InAppToastData? _inAppToast;
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
    final nextToast = _provider.toast;
    if (widget.key != nextToast?.key && nextToast != null) {
      return;
    }

    if (_inAppToast?.isEqual(nextToast) == true) {
      return;
    }

    if (nextToast == null && _inAppToast == null) {
      return;
    }

    if (nextToast == null && _inAppToast != null) {
      _onRemoveToastHandler(_inAppToast!);
      return;
    }

    if (nextToast != null) {
      if (_inAppToast == null) {
        _onShowToastHandler(nextToast);
      } else {
        _onReplaceToastHandler(nextToast);
      }
    }
  }

  Future<void> _onShowToastHandler(InAppToastData toast) async {
    if (_inAppToast != null) {
      return;
    }

    if (mounted) {
      setState(() {
        _inAppToast = toast;
        _isShowing = true;
      });
    }
  }

  Future<void> _onRemoveToastHandler(InAppToastData toast) async {
    if (_inAppToast?.isEqual(toast) != true) {
      return;
    }

    await _onHideToastHandler();
    if (mounted) {
      setState(() {
        _inAppToast = null;
      });
    }

    await Future.delayed(_delayDuration);
    _provider.removeToast(toast);
  }

  Future<void> _onReplaceToastHandler(InAppToastData toast) async {
    await _onHideToastHandler();
    if (mounted) {
      setState(() {
        _inAppToast = null;
      });
    }

    await Future.delayed(_delayDuration);
    _onShowToastHandler(toast);
  }

  Future<void> _onHideToastHandler() async {
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
      onTap: _inAppToast != null
          ? () => _onRemoveToastHandler(_inAppToast!)
          : null,
      child: _InAppToastWidget(
        toast: _inAppToast,
        isShowing: _isShowing,
      ),
    );
  }
}

class _InAppToastWidget extends StatefulWidget {
  final InAppToastData? toast;
  final bool isShowing;

  const _InAppToastWidget({
    required this.toast,
    required this.isShowing,
  });

  @override
  State<_InAppToastWidget> createState() => _InAppToastWidgetState();
}

class _InAppToastWidgetState extends State<_InAppToastWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  InAppToastData? _toast;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: OtherConstants.defaultAnimationDuration,
    );
    _toast = widget.toast;
  }

  @override
  void didUpdateWidget(covariant _InAppToastWidget oldWidget) {
    if (widget.isShowing) {
      _animationController.forward();
      _toast = widget.toast;
    } else {
      _animationController.reverse();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildLabelWidget(BuildContext context) {
    if (_toast?.label is String) {
      return CustomText(
        text: _toast!.label,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: ColorConstants.inAppToastText(),
        ),
        maxLines: 3,
        isVerticalCentered: false,
      );
    }

    return _toast?.label ?? SizedBox();
  }

  Widget _buildDescriptionWidget(BuildContext context) {
    if (_toast?.description is String) {
      return CustomText(
        text: _toast!.description,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 11.0,
          fontWeight: FontWeight.w500,
          height: 14.0 / 11.0,
          color: ColorConstants.inAppToastText(),
        ),
        maxLines: 3,
        isVerticalCentered: false,
      );
    }

    return _toast?.description ?? SizedBox();
  }

  Widget _buildToastWidget(BuildContext context) {
    if (_toast?.description == null) {
      return SizedBox();
    }

    final isCustom = _toast?.label != null || _toast?.actionText != null;
    if (isCustom) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            ImageConstants.icError,
            height: 16.0,
            width: 16.0,
          ),
          SizedBox(width: 8.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_toast?.label != null) ...[
                  _buildLabelWidget(context),
                  SizedBox(height: 8.0),
                ],
                _buildDescriptionWidget(context),
                if (_toast?.actionText != null) ...[
                  SizedBox(height: 16.0),
                  CustomSmallButton(
                    content: _toast!.actionText!,
                    onTap: () {
                      if (_toast?.onAction != null) {
                        _toast!.onAction!();
                      }
                    },
                    type: CustomSmallButtonType.attention,
                  ),
                ],
              ],
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        SvgPicture.asset(
          ImageConstants.icError,
          height: 16.0,
          width: 16.0,
        ),
        SizedBox(width: 8.0),
        Flexible(
          child: _buildDescriptionWidget(context),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, child) {
        return Container(
          margin: EdgeInsets.only(
            top: _animationController.value * 16.0,
          ),
          child: Opacity(
            opacity: _animationController.value,
            child: Align(
              heightFactor: _animationController.value,
              child: Transform.scale(
                scaleY: _animationController.value,
                child: Container(
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: ColorConstants.textFieldTextErrorBG(),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: _buildToastWidget(context),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
