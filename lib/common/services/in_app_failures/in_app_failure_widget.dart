part of 'in_app_failure_provider.dart';

class InAppFailureBackground extends StatefulWidget {
  const InAppFailureBackground({super.key});

  @override
  State<InAppFailureBackground> createState() => _InAppFailureBackgroundState();
}

class _InAppFailureBackgroundState extends State<InAppFailureBackground> {
  final _inAppFailureProvider = locator<InAppFailureProvider>();
  bool _isRequestInProgress = false;

  @override
  void initState() {
    super.initState();
    _inAppFailureProvider.addListener(_onProviderListener);
  }

  @override
  void dispose() {
    _inAppFailureProvider.removeListener(_onProviderListener);
    super.dispose();
  }

  Future<void> _onProviderListener() async {
    if (!_inAppFailureProvider.isShowing || _isRequestInProgress) {
      return;
    }

    setState(() {
      _isRequestInProgress = true;
    });

    await DialogsUtil.showDialogCustom<bool?>(
      CustomWarningDialog(
        title: _inAppFailureProvider.primaryType!.getTitle(),
        content: _inAppFailureProvider.primaryType!.getDescription(),
        buttonText: _inAppFailureProvider.primaryType!.getButtonTitle(),
        buttonCallback: _onTryAgainHandler,
      ),
    );

    if (_inAppFailureProvider.primaryOptions?.onGoBack != null) {
      _inAppFailureProvider.primaryOptions!.onGoBack!();
    }

    await Future.delayed(StyleConstants.defaultDelayDuration);
    _inAppFailureProvider.clear();

    setState(() {
      _isRequestInProgress = false;
    });
  }

  Future<void> _onTryAgainHandler() async {
    if (_isRequestInProgress || !_inAppFailureProvider.isHaveFailures) {
      return;
    }

    setState(() {
      _isRequestInProgress = true;
    });

    await _inAppFailureProvider.processAllFailures();
    if (_inAppFailureProvider.primaryOptions?.onGoNext != null) {
      await _inAppFailureProvider.primaryOptions!.onGoNext!();
    }

    setState(() {
      _isRequestInProgress = false;
    });
  }

  void _onGoBackHandler() {
    if (_inAppFailureProvider.primaryOptions?.onGoBack != null) {
      _inAppFailureProvider.primaryOptions!.onGoBack!();
    }

    _inAppFailureProvider.clear();
  }

  void _onPopInvokedCallback(bool value) {
    if (value) {
      _onGoBackHandler();
    }
  }

  Widget _buildFailureWidget(InAppFailureProvider provider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OpacityWrapper(
          isOpaque: _isRequestInProgress,
          child: Column(
            children: [
              SizedBox(
                height: 112.0,
                child: Image.asset(ImageConstants.igSleepCat),
              ),
              const SizedBox(
                height: 12.0,
              ),
              CustomText(
                text: provider.primaryType?.getTitle() ?? 'Unknown',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: ColorConstants.transparent,
                ),
              ),
              if (provider.primaryType != null) ...[
                const SizedBox(
                  height: 6.0,
                ),
                CustomText(
                  text: provider.primaryType?.getDescription() ?? 'Unknown',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: ColorConstants.transparent,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(
          height: 24.0,
        ),
        CustomBaseButton(
          content: provider.primaryType?.getButtonTitle() ?? 'Unknown',
          height: 40.0,
          padding: const EdgeInsets.symmetric(
            vertical: SizeConstants.defaultPadding * 0.5,
            horizontal: SizeConstants.defaultPadding * 2.0,
          ),
          textStyle: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            height: 16.0 / 14.0,
            color: ColorConstants.transparent,
          ),
          isSlim: true,
          isProcessing: _isRequestInProgress,
          onCallback: _onTryAgainHandler,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final inAppFailureProvider = context.watch<InAppFailureProvider>();
    return PopScope(
      canPop: !_isRequestInProgress,
      onPopInvoked: _onPopInvokedCallback,
      child: AnimatedSwitcher(
        duration: StyleConstants.defaultAnimationDuration,
        child: inAppFailureProvider.isShowing
            ? DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (!inAppFailureProvider.isImportant)
                      SafeArea(
                        child: CustomAppBar(
                          onBackCallback: _onGoBackHandler,
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 60.0,
                        horizontal: SizeConstants.isSmallDevice() ? 60.0 : 80.0,
                      ),
                      child: _buildFailureWidget(inAppFailureProvider),
                    ),
                  ],
                ),
              )
            : null,
      ),
    );
  }
}
