import 'package:flutter/material.dart';

import '../../../constants/sizes.dart';
import 'text_button.dart';

class SandboxOutlinedTextButton extends StatelessWidget {
  final dynamic content;
  final VoidCallback onCallback;
  final double height;
  final double? width;
  final EdgeInsets? padding;
  final BorderRadiusGeometry? borderRadius;
  final TextStyle? textStyle;
  final bool isRounded, isSlim, isDisabled, isProcessing;

  const SandboxOutlinedTextButton({
    Key? key,
    required this.content,
    required this.onCallback,
    this.height = SizeConstants.defaultButtonHeight,
    this.width,
    this.padding = const EdgeInsets.symmetric(
      vertical: 8.0,
      horizontal: 16.0,
    ),
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.textStyle,
    this.isRounded = false,
    this.isSlim = false,
    this.isDisabled = false,
    this.isProcessing = false,
  })  : assert(content is String || content is Widget),
        assert(height >= 0 && (width == null || width >= 0)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isDisabled,
      child: Container(
        height: height,
        width: isSlim ? null : width ?? double.maxFinite,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border.all(
            width: 2.0,
            color: SandboxTextButton.getButtonColor(context, isDisabled: isDisabled),
          ),
          borderRadius: isRounded
              ? BorderRadius.all(Radius.circular(height))
              : borderRadius,
          boxShadow: [
            if (!isDisabled)
              BoxShadow(
                color: SandboxTextButton.getButtonColor(context, isDisabled: isDisabled).withOpacity(0.6),
                offset: const Offset(0.0, 4.0),
                blurRadius: 12.0,
              ),
          ],
        ),
        child: TextButton(
          onPressed: onCallback,
          style: TextButton.styleFrom(
            padding: padding,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: isRounded
                  ? BorderRadius.all(Radius.circular(height))
                  : borderRadius ?? BorderRadius.zero,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: SandboxTextButton.buildContentWidget(
                  content,
                  context,
                  textStyle: textStyle,
                  isDisabled: isDisabled,
                ),
              ),
              SandboxTextButton.buildProgressIndicatorWidget(
                context,
                withProgress: isProcessing,
                isDisabled: isDisabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
