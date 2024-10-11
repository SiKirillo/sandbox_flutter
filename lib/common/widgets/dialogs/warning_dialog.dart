part of '../../common.dart';

class CustomWarningDialog extends StatefulWidget {
  final String title;
  final dynamic content;
  final String? buttonText;
  final Function()? onButtonCallback;
  final Function(bool, dynamic)? onPopInvoked;
  final bool isCanPop;

  const CustomWarningDialog({
    super.key,
    required this.title,
    required this.content,
    this.buttonText,
    this.onButtonCallback,
    this.onPopInvoked,
    this.isCanPop = true,
  }) : assert(content is Widget || content is String);

  @override
  State<CustomWarningDialog> createState() => _CustomWarningDialogState();
}

class _CustomWarningDialogState extends State<CustomWarningDialog> {
  bool _isRequestInProgress = false;

  Future<void> _onButtonHandler() async {
    if (widget.onButtonCallback != null) {
      setState(() {
        _isRequestInProgress = true;
      });

      await widget.onButtonCallback!();

      setState(() {
        _isRequestInProgress = false;
      });
    }

    Navigator.of(context).pop(true);
  }

  Widget _buildContentWidget() {
    if (widget.content is Widget) {
      return widget.content;
    }

    return CustomText(
      text: widget.content,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        height: 16.0 / 12.0,
      ),
      textAlign: TextAlign.center,
      maxLines: 5,
    );
  }

  Widget _buildButtonWidget() {
    return SizedBox(
      height: 42.0,
      width: double.maxFinite,
      child: Material(
        color: ColorConstants.buttonAttentionColor(),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8.0),
          bottomRight: Radius.circular(8.0),
        ),
        child: InkWell(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(8.0),
            bottomRight: Radius.circular(8.0),
          ),
          onTap: _onButtonHandler,
          child: Center(
            child: CustomText(
              text: widget.buttonText!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ColorConstants.buttonTextSecondaryColor(),
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
      child: AlertDialog(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        titlePadding: EdgeInsets.zero,
        title: Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: CustomText(
                          text: widget.title,
                          style: Theme.of(context).dialogTheme.titleTextStyle?.copyWith(
                            color: ColorConstants.textBlack(),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Flexible(
                        child: _buildContentWidget(),
                      ),
                    ],
                  ),
                ),
                if (widget.buttonText != null) ...[
                  const CustomDivider(),
                  AbsorbPointer(
                    absorbing: _isRequestInProgress,
                    child: _buildButtonWidget(),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
