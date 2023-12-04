import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../constants/style.dart';
import '../indicators/progress_indicator.dart';
import '../texts.dart';

class CustomBaseButton extends StatelessWidget {
  final dynamic content;
  final VoidCallback onCallback;
  final double height;
  final double? width;
  final EdgeInsets? padding;
  final TextStyle? textStyle;
  final bool isSlim;
  final bool isBlocked;
  final bool isProcessing;
  final bool withShadow;

  const CustomBaseButton({
    Key? key,
    required this.content,
    required this.onCallback,
    this.height = SizeConstants.defaultButtonHeight,
    this.width,
    this.padding = const EdgeInsets.symmetric(
      vertical: SizeConstants.defaultPadding * 0.5,
      horizontal: SizeConstants.defaultPadding,
    ),
    this.textStyle,
    this.isSlim = false,
    this.isBlocked = false,
    this.isProcessing = false,
    this.withShadow = true,
  })  : assert(content is Widget || content is String),
        super(key: key);

  TextStyle? _getTextButtonStyle(BuildContext context) {
    final buttonTextStyle = textStyle?.copyWith(
      color: isBlocked ? ColorConstants.buttonColor() : null,
    );

    return buttonTextStyle ?? Theme.of(context).textTheme.displayMedium?.copyWith(
      color: isBlocked
          ? ColorConstants.buttonColor()
          : ColorConstants.buttonColor(),
    );
  }

  Color? _getProgressIndicatorColor(BuildContext context) {
    if (textStyle != null && !isBlocked) {
      return _getTextButtonStyle(context)?.color;
    }

    return isBlocked
        ? ColorConstants.buttonColor()
        : ColorConstants.buttonColor();
  }

  Widget _buildContentWidget(BuildContext context) {
    return content is Widget ? content : CustomText(
      text: content,
      maxLines: 1,
      style: _getTextButtonStyle(context),
      isVerticalCentered: false,
    );
  }

  BoxDecoration? _getButtonDecoration(BuildContext context) {
    return BoxDecoration(
      color: isBlocked ? ColorConstants.buttonColor() : null,
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      boxShadow: [
        if (!isBlocked && withShadow)
          BoxShadow(
            color: ColorConstants.buttonColor(),
            offset: const Offset(0.0, 4.0),
            blurRadius: 12.0,
          ),
      ],
      gradient: isBlocked
          ? null
          : LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                ColorConstants.progressBarGradient().first,
                ColorConstants.progressBarGradient().last,
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isBlocked,
      child: Container(
        height: height,
        width: isSlim ? null : width ?? double.maxFinite,
        decoration: _getButtonDecoration(context),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          child: TextButton(
            onPressed: onCallback,
            style: TextButton.styleFrom(
              padding: padding,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: _buildContentWidget(context),
                ),
                AnimatedOpacity(
                  duration: StyleConstants.defaultAnimationDuration,
                  opacity: isProcessing ? 1.0 : 0.0,
                  child: AnimatedContainer(
                    duration: StyleConstants.defaultAnimationDuration,
                    width: isProcessing ? 20.0 : 0.0,
                    margin: EdgeInsets.only(
                      left: isProcessing ? 8.0 : 0.0,
                    ),
                    child: CustomProgressIndicator(
                      color: _getProgressIndicatorColor(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
