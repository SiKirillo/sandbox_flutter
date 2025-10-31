part of '../../common.dart';

class DialogWrapper extends StatelessWidget {
  final dynamic label, description;
  final Function(bool, dynamic)? onPopInvoked;
  final VoidCallback? onClose;
  final DialogWrapperOptions options;
  final bool isProcessing;
  final bool isDisabled;
  final Widget child;

  const DialogWrapper({
    super.key,
    this.label,
    this.description,
    this.onPopInvoked,
    this.onClose,
    this.options = const DialogWrapperOptions(),
    this.isProcessing = false,
    this.isDisabled = false,
    required this.child,
  })  : assert(label is String || label is Widget || label == null),
        assert(description is String || description is Widget || description == null);

  Future<void> _closeButtonHandler(BuildContext context) async {
    if (onClose != null) {
      onClose!();
    } else {
      FocusManager.instance.primaryFocus?.unfocus();
      Navigator.of(context).pop();
    }
  }

  Widget? _buildLabelWidget(BuildContext context) {
    if (label is String) {
      return CustomText(
        text: label!,
        style: options.labelStyle ?? Theme.of(context).textTheme.headlineSmall,
        textAlign: TextAlign.center,
        maxLines: 2,
      );
    }

    return label;
  }

  Widget? _buildDescriptionWidget(BuildContext context) {
    if (description is String) {
      return CustomText(
        text: description!,
        style: options.descriptionStyle ?? Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: ColorConstants.textBlack().withValues(alpha: 0.5),
        ),
        textAlign: TextAlign.center,
        maxLines: 5,
      );
    }

    return description;
  }

  Widget _buildDialogWidget(BuildContext context) {
    final labelWidget = _buildLabelWidget(context);
    final descriptionWidget = _buildDescriptionWidget(context);

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        AbsorbPointer(
          absorbing: isProcessing || isDisabled,
          child: OpacityWrapper(
            isOpaque: isProcessing || isDisabled,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: options.labelAlignment,
              children: [
                if (labelWidget != null || descriptionWidget != null) ...[
                  Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.only(
                      top: options.labelPadding.top,
                      left: options.labelPadding.left,
                      right: options.labelPadding.right,
                    ),
                    child: Column(
                      crossAxisAlignment: options.labelAlignment,
                      children: [
                        if (labelWidget != null)
                          Padding(
                            padding: options.withCloseButton
                                ? EdgeInsets.only(right: options.closeButtonPadding.right)
                                : EdgeInsets.zero,
                            child: labelWidget,
                          ),
                        if (labelWidget != null && descriptionWidget != null)
                          SizedBox(
                            height: options.labelIndent,
                          ),
                        if (descriptionWidget != null) descriptionWidget,
                      ],
                    ),
                  ),
                ],
                SizedBox(
                  height: options.contentPadding.top,
                ),
                Flexible(
                  child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.only(
                      bottom: options.contentPadding.bottom,
                      left: options.contentPadding.left,
                      right: options.contentPadding.right,
                    ),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (options.withScrollTab)
          Container(
            height: 3.0,
            width: 32.0,
            margin: EdgeInsets.only(top: 4.0),
            decoration: BoxDecoration(
              color: ColorConstants.bottomSheetScrollTab(),
              borderRadius: BorderRadius.all(Radius.circular(3.0)),
            ),
          ),
        if (options.withCloseButton)
          Positioned(
            top: 0.0,
            right: 0.0,
            child: GestureDetector(
              onTap: () => _closeButtonHandler(context),
              child: Container(
                padding: options.closeButtonPadding,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: SvgPicture.asset(
                  ImageConstants.icClose,
                  height: SizeConstants.defaultButtonIconSize,
                  width: SizeConstants.defaultButtonIconSize,
                ),
              ),
            ),
          ),
        if (isProcessing)
          Positioned(
            top: 0.0,
            bottom: 0.0,
            child: Center(
              child: InAppOverlayPlaceholder(text: options.overlayText),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: options.isCanPop,
      onPopInvokedWithResult: onPopInvoked,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height - MediaQuery.viewPaddingOf(context).vertical,
          maxWidth: double.maxFinite,
        ),
        padding: EdgeInsets.only(
          bottom: options.withKeyboardResize ? MediaQuery.viewInsetsOf(context).bottom : 0.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: _buildDialogWidget(context),
            ),
          ],
        ),
      ),
    );
  }
}

class DialogWrapperOptions {
  final EdgeInsets labelPadding, contentPadding, closeButtonPadding;
  final double labelIndent;
  final CrossAxisAlignment labelAlignment;
  final TextStyle? labelStyle, descriptionStyle;
  final String? overlayText;
  final bool isCanPop;
  final bool withCloseButton;
  final bool withScrollTab;
  final bool withKeyboardResize;

  const DialogWrapperOptions({
    this.labelPadding = const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 0.0),
    this.contentPadding = const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 32.0),
    this.closeButtonPadding = const EdgeInsets.all(12.0),
    this.labelIndent = 8.0,
    this.labelAlignment = CrossAxisAlignment.center,
    this.labelStyle,
    this.descriptionStyle,
    this.overlayText,
    this.isCanPop = true,
    this.withCloseButton = false,
    this.withScrollTab = false,
    this.withKeyboardResize = true,
  });
}
