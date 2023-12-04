import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/images.dart';
import '../../../constants/sizes.dart';
import '../buttons/base_button.dart';
import '../texts.dart';

class CustomWarningDialog extends StatefulWidget {
  final String title;
  final dynamic content;
  final String? buttonText;
  final Function()? buttonCallback;

  const CustomWarningDialog({
    Key? key,
    required this.title,
    required this.content,
    this.buttonText,
    this.buttonCallback,
  })  : assert(content is Widget || content is String),
        super(key: key);

  @override
  State<CustomWarningDialog> createState() => _CustomWarningDialogState();
}

class _CustomWarningDialogState extends State<CustomWarningDialog> {
  bool _isRequestInProgress = false;

  void _onGoBackHandler() {
    Navigator.of(context).pop(false);
  }

  Future<void> _onGoNextHandler() async {
    if (widget.buttonCallback != null) {
      setState(() {
        _isRequestInProgress = true;
      });

      await widget.buttonCallback!();

      setState(() {
        _isRequestInProgress = false;
      });
    }

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      titlePadding: EdgeInsets.zero,
      title: Stack(
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 36.0,
              bottom: 24.0,
              left: 24.0,
              right: 24.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(
                  text: widget.title,
                  style: Theme.of(context).dialogTheme.titleTextStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 12.0,
                ),
                widget.content is Widget
                    ? widget.content
                    : CustomText(
                  text: widget.content,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ColorConstants.transparent,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (widget.buttonText != null) ...[
                  const SizedBox(
                    height: 24.0,
                  ),
                  CustomBaseButton(
                    content: widget.buttonText!,
                    onCallback: _onGoNextHandler,
                    isProcessing: _isRequestInProgress,
                  ),
                ],
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
                right: 8.0,
                bottom: 4.0,
              ),
              child: GestureDetector(
                onTap: _onGoBackHandler,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SizedBox.square(
                    dimension: SizeConstants.defaultIconSize,
                    child: Image.asset(ImageConstants.icClose),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
