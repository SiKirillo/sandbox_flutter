part of '../../common.dart';

class DialogWrapper extends StatelessWidget {
  final Widget child;
  final dynamic label, description;
  final TextStyle? labelStyle, descriptionStyle;
  final Alignment contentAlignment;
  final EdgeInsets labelPadding, contentPadding, closeButtonPadding;
  final Function(bool, dynamic)? onPopInvoked;
  final bool isCanPop;
  final bool withCloseButton;
  final bool withPadding;
  final bool isDisabled;
  final bool isHidden;

  const DialogWrapper({
    super.key,
    required this.child,
    this.label,
    this.description,
    this.labelStyle,
    this.descriptionStyle,
    this.contentAlignment = Alignment.topCenter,
    this.labelPadding = const EdgeInsets.only(
      top: 20.0,
      left: 18.0,
      right: 18.0,
    ),
    this.contentPadding = const EdgeInsets.only(
      top: 24.0,
      bottom: 20.0,
      left: 18.0,
      right: 18.0,
    ),
    this.closeButtonPadding = const EdgeInsets.all(12.0),
    this.onPopInvoked,
    this.isCanPop = true,
    this.withCloseButton = false,
    this.withPadding = true,
    this.isDisabled = false,
    this.isHidden = false,
  })  : assert(label is String || label is Widget || label == null),
        assert(description is String || description is Widget || description == null);

  static const _onShowDuration = Duration(milliseconds: 200);
  static const _onHideDuration = Duration(milliseconds: 250);

  Future<void> _closeButtonHandler(BuildContext context) async {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop();
  }

  Widget _buildDialogWrapperWidget(BuildContext context) {
    final Widget? labelContent = label is Widget
        ? label
        : label is String
            ? CustomText(
                text: label!,
                style: labelStyle ?? Theme.of(context).dialogTheme.titleTextStyle,
                textAlign: TextAlign.center,
                maxLines: 2,
              )
            : null;

    final Widget? descriptionContent = description is Widget
        ? description
        : description is String
            ? CustomText(
                text: description!,
                style: descriptionStyle,
                textAlign: TextAlign.center,
                maxLines: 5,
              )
            : null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Stack(
          alignment: contentAlignment,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: labelPadding.top,
                left: labelPadding.left,
                right: labelPadding.right,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (labelContent != null)
                    Padding(
                      padding: withCloseButton
                          ? EdgeInsets.symmetric(horizontal: closeButtonPadding.right)
                          : EdgeInsets.zero,
                      child: labelContent,
                    ),
                  if (labelContent != null && descriptionContent != null)
                    const SizedBox(
                      height: 8.0,
                    ),
                  if (descriptionContent != null) descriptionContent,
                ],
              ),
            ),
            if (withCloseButton)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: closeButtonPadding.top,
                    right: closeButtonPadding.right,
                    bottom: 8.0,
                  ),
                  child: GestureDetector(
                    onTap: () => _closeButtonHandler(context),
                    child: SizedBox.square(
                      dimension: SizeConstants.defaultIconSize,
                      child: Image.asset(ImageConstants.icClose),
                    ),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(
          height: contentPadding.top,
        ),
        Flexible(
          child: Padding(
            padding: withPadding
                ? EdgeInsets.only(
                    bottom: contentPadding.bottom,
                    left: contentPadding.left,
                    right: contentPadding.right,
                  )
                : EdgeInsets.zero,
            child: child,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: isCanPop,
      onPopInvokedWithResult: onPopInvoked,
      child: AbsorbPointer(
        absorbing: isDisabled,
        child: OpacityWrapper(
          isOpaque: isDisabled,
          child: AnimatedAlign(
            duration: isHidden ? _onHideDuration : _onShowDuration,
            alignment: Alignment.center,
            heightFactor: isHidden ? 0.0 : 1.0,
            child: AnimatedOpacity(
              duration: isHidden ? _onHideDuration : _onShowDuration,
              opacity: isHidden ? 0.0 : 1.0,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: _buildDialogWrapperWidget(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
