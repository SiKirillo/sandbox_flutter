part of '../../common.dart';

class CustomActionDialog extends StatelessWidget {
  final String title;
  final dynamic content;
  final String cancelText, actionText;
  final VoidCallback onCancel, onAction;
  final Function(bool, dynamic)? onPopInvoked;
  final bool isCanPop;
  final bool isDisabled;

  const CustomActionDialog({
    super.key,
    required this.title,
    required this.content,
    required this.cancelText,
    required this.actionText,
    required this.onCancel,
    required this.onAction,
    this.onPopInvoked,
    this.isCanPop = true,
    this.isDisabled = false,
  }) : assert(content is String || content is Widget);

  Widget _buildMaterialDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      title: CustomText(
        text: title,
        style: Theme.of(context).dialogTheme.titleTextStyle,
        maxLines: 2,
      ),
      content: content is Widget
          ? content
          : CustomText(
              text: content!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ColorConstants.textGrey(),
              ),
              maxLines: 5,
            ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: CustomText(
            text: cancelText.toUpperCase(),
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              height: 20.0 / 14.0,
              color: ColorConstants.textBlue(),
            ),
            maxLines: 1,
          ),
        ),
        TextButton(
          onPressed: onAction,
          child: CustomText(
            text: actionText.toUpperCase(),
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              height: 20.0 / 14.0,
              color: ColorConstants.attentionColor(),
            ),
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildCupertinoDialog(BuildContext context) {
    return cupertino.CupertinoAlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            text: title,
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              height: 22.0 / 16.0,
              color: Theme.of(context).dialogTheme.titleTextStyle?.color,
            ),
            maxLines: 2,
          ),
        ],
      ),
      content: content is Widget
          ? content
          : CustomText(
              text: content!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontFamily: 'OpenSans',
                height: 18.0 / 13.0,
                color: ColorConstants.textGrey(),
              ),
              textAlign: TextAlign.center,
              maxLines: 5,
            ),
      actions: [
        TextButton(
          onPressed: onCancel,
          style: ButtonStyle(
            overlayColor: WidgetStateColor.resolveWith((states) => ColorConstants.transparent),
          ),
          child: CustomText(
            text: cancelText,
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              height: 22.0 / 16.0,
              color: ColorConstants.textBlue(),
            ),
          ),
        ),
        TextButton(
          onPressed: onAction,
          style: ButtonStyle(
            overlayColor: WidgetStateColor.resolveWith((states) => ColorConstants.transparent),
          ),
          child: CustomText(
            text: actionText,
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              height: 22.0 / 16.0,
              color: ColorConstants.attentionColor(),
            ),
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
          child: kIsWeb || Platform.isAndroid
              ? _buildMaterialDialog(context)
              : _buildCupertinoDialog(context),
        ),
      ),
    );
  }
}
