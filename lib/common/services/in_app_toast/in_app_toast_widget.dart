part of 'in_app_toast_provider.dart';

class InAppToastBackground extends StatefulWidget {
  const InAppToastBackground({required super.key});

  @override
  State<InAppToastBackground> createState() => _InAppToastBackgroundState();
}

class _InAppToastBackgroundState extends State<InAppToastBackground> {
  final _delayDuration = const Duration(milliseconds: 50);

  final _inAppToastProvider = locator<InAppToastProvider>();
  InAppToastData? _inAppToast;
  bool _isShowing = false;

  @override
  void initState() {
    super.initState();
    _inAppToastProvider.addListener(_onProviderListener);
  }

  @override
  void dispose() {
    _inAppToastProvider.removeListener(_onProviderListener);
    super.dispose();
  }

  Future<void> _onProviderListener() async {
    final nextToast = _inAppToastProvider.toast;
    if (widget.key != nextToast?.key && nextToast != null) {
      return;
    }

    if (_inAppToast?.isSameToast(nextToast) == true) {
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
    if (_inAppToast?.isSameToast(toast) != true) {
      return;
    }

    await _onHideToastHandler();
    if (mounted) {
      setState(() {
        _inAppToast = null;
      });
    }

    await Future.delayed(_delayDuration);
    _inAppToastProvider.removeToast(toast);
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

    await Future.delayed(StyleConstants.defaultAnimationDuration);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: widget.key,
      onTap: _inAppToast != null
          ? () => _onRemoveToastHandler(_inAppToast!)
          : null,
      child: _InAppToastBody(
        toast: _inAppToast,
        isShowing: _isShowing,
      ),
    );
  }
}

class _InAppToastBody extends StatelessWidget {
  final dynamic toast;
  final bool isShowing;

  const _InAppToastBody({
    required this.toast,
    required this.isShowing,
  })  : assert(toast is InAppToastData || toast is String || toast == null);

  Widget _buildInfoBody(BuildContext context) {
    if (toast is InAppToastData) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: toast?.comment ?? '',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: ColorConstants.attentionColor(),
              height: 16.0 / 14.0,
            ),
            maxLines: 3,
          ),
        ],
      );
    }

    if (toast is String) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: toast,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: ColorConstants.attentionColor(),
              height: 16.0 / 14.0,
            ),
            maxLines: 3,
          ),
        ],
      );
    }

    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: StyleConstants.defaultAnimationDuration,
      opacity: isShowing ? 1.0 : 0.0,
      child: AnimatedContainer(
        duration: StyleConstants.defaultAnimationDuration,
        padding: EdgeInsets.symmetric(
          vertical: isShowing ? 10.0 : 0.0,
          horizontal: 12.0,
        ),
        margin: EdgeInsets.only(
          top: isShowing ? 16.0 : 0.0,
        ),
        decoration: BoxDecoration(
          color: ColorConstants.attentionColor().withOpacity(0.2),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        ),
        child: AnimatedAlign(
          duration: StyleConstants.defaultAnimationDuration,
          alignment: Alignment.centerLeft,
          heightFactor: isShowing ? 1.0 : 0.0,
          child: _buildInfoBody(context),
        ),
      ),
    );
  }
}
