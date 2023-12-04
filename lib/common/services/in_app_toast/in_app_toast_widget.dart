part of 'in_app_toast_provider.dart';

class InAppToastBackground extends StatefulWidget {
  final double margin;

  const InAppToastBackground({
    required Key? key,
    this.margin = 16.0,
  }) : super(key: key);

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
    _inAppToastProvider.addListener(_onProviderListener);
    super.dispose();
  }

  Future<void> _onProviderListener() async {
    final nextToast = _inAppToastProvider.toast;
    if (widget.key != nextToast?.key) {
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
      child: InAppToastBody(
        toast: _inAppToast,
        isShowing: _isShowing,
        margin: widget.margin,
      ),
    );
  }
}

class InAppToastBody extends StatelessWidget {
  final dynamic toast;
  final bool isShowing;
  final double margin;

  const InAppToastBody({
    Key? key,
    required this.toast,
    required this.isShowing,
    this.margin = 16.0,
  })  : assert(toast is InAppToastData || toast is String || toast == null),
        super(key: key);

  Widget _buildInfoBody(BuildContext context) {
    if (toast is InAppToastData) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: toast?.message ?? '',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: ColorConstants.transparent,
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
              color: ColorConstants.transparent,
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
          top: isShowing ? margin : 0.0,
        ),
        decoration: const BoxDecoration(
          color: ColorConstants.transparent,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
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
