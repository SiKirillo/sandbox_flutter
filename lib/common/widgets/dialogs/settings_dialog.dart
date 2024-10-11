part of '../../common.dart';

class CustomSettingsDialog extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String cancelText, actionText;
  final VoidCallback? onCancel;
  final VoidCallback onAction;
  final Function(bool, dynamic)? onPopInvoked;
  final bool isCanPop;
  final bool isImportant;
  final bool isDisabled;
  final bool isHidden;

  const CustomSettingsDialog({
    super.key,
    required this.title,
    this.subtitle,
    required this.cancelText,
    required this.actionText,
    this.onCancel,
    required this.onAction,
    this.onPopInvoked,
    this.isCanPop = true,
    this.isImportant = false,
    this.isDisabled = false,
    this.isHidden = false,
  });

  static const _onShowDuration = Duration(milliseconds: 200);
  static const _onHideDuration = Duration(milliseconds: 250);

  @override
  State<CustomSettingsDialog> createState() => _CustomSettingsDialogState();
}

class _CustomSettingsDialogState extends State<CustomSettingsDialog> {
  Widget _buildButtonWidget(
    String text,
    VoidCallback onTap, {
    bool isCancel = false,
    bool isLast = false,
  }) {
    BorderRadius? borderRadius;
    Color textColor = ColorConstants.buttonTextSecondaryColor();

    if (isCancel) {
      borderRadius = const BorderRadius.all(Radius.circular(8.0));
      textColor = ColorConstants.textBlack();
    }

    if (isLast) {
      borderRadius = const BorderRadius.only(
        bottomLeft: Radius.circular(8.0),
        bottomRight: Radius.circular(8.0),
      );
    }

    if (isLast && widget.isImportant) {
      textColor = ColorConstants.buttonAttentionColor();
    }

    return SizedBox(
      height: 42.0,
      width: double.maxFinite,
      child: Material(
        color: Theme.of(context).bottomSheetTheme.backgroundColor,
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: Center(
            child: CustomText(
              text: text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textColor,
              ),
              isVerticalCentered: false,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.isCanPop,
      onPopInvokedWithResult: widget.onPopInvoked,
      child: AbsorbPointer(
        absorbing: widget.isDisabled,
        child: OpacityWrapper(
          isOpaque: widget.isDisabled,
          child: AnimatedAlign(
            duration: widget.isHidden ? CustomSettingsDialog._onHideDuration : CustomSettingsDialog._onShowDuration,
            alignment: Alignment.center,
            heightFactor: widget.isHidden ? 0.0 : 1.0,
            child: AnimatedOpacity(
              duration: widget.isHidden ? CustomSettingsDialog._onHideDuration : CustomSettingsDialog._onShowDuration,
              opacity: widget.isHidden ? 0.0 : 1.0,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Theme.of(context).bottomSheetTheme.backgroundColor,
                        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: CustomText(
                              text: widget.title,
                              style: Theme.of(context).dialogTheme.titleTextStyle?.copyWith(
                                color: ColorConstants.textBlack(),
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          ),
                          if (widget.subtitle != null) ...[
                            const SizedBox(
                              height: 12.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                              ),
                              child: CustomText(
                                text: widget.subtitle!,
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                                maxLines: 5,
                              ),
                            ),
                          ],
                          const SizedBox(
                            height: 16.0,
                          ),
                          const CustomDivider(),
                          _buildButtonWidget(
                            widget.actionText,
                            widget.onAction,
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    _buildButtonWidget(
                      widget.cancelText,
                      widget.onCancel ?? () => Navigator.of(context).pop(),
                      isCancel: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
