import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sandbox_flutter/common/providers/theme_provider.dart';
import 'package:sandbox_flutter/common/widgets/progress_indicators/progress_indicator.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../texts.dart';

class SandboxTextButton extends StatelessWidget {
  final dynamic content;
  final VoidCallback onCallback;
  final double height;
  final double? width;
  final EdgeInsets? padding;
  final BorderRadiusGeometry? borderRadius;
  final TextStyle? textStyle;
  final bool isRounded, isSlim, isDisabled, isProcessing;

  const SandboxTextButton({
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

  static const onProgressDuration = Duration(milliseconds: 200);

  static Widget buildContentWidget(
    dynamic content,
    BuildContext context, {
    TextStyle? textStyle,
    bool isDisabled = false,
  }) {
    assert(content is String || content is Widget);
    if (content is Widget) {
      return content;
    }

    late final Color textColor;
    switch (context.watch<ThemeProvider>().type) {
      case ThemeStyleType.light: {
        textColor = ColorConstants.light.black500;
        break;
      }


      case ThemeStyleType.dark: {
        textColor = ColorConstants.dark.white500;
        break;
      }
    }

    return SandboxText(
      text: content,
      style: textStyle ?? Theme.of(context).textTheme.displayMedium?.copyWith(
        color: textColor.withOpacity(isDisabled ? 0.6 : 1.0),
      ),
      maxLines: 1,
      textAlign: TextAlign.center,
      isVerticalCentered: false,
    );
  }

  static Widget buildProgressIndicatorWidget(
    BuildContext context, {
    bool withProgress = false,
    bool isDisabled = false,
  }) {
    late final Color indicatorColor;
    switch (context.watch<ThemeProvider>().type) {
      case ThemeStyleType.light: {
        indicatorColor = ColorConstants.light.black400;
        break;
      }


      case ThemeStyleType.dark: {
        indicatorColor = ColorConstants.dark.white500;
        break;
      }
    }

    return AnimatedOpacity(
      duration: SandboxTextButton.onProgressDuration,
      opacity: withProgress ? 1.0 : 0.0,
      child: AnimatedContainer(
        duration: SandboxTextButton.onProgressDuration,
        width: withProgress ? 20.0 : 0.0,
        margin: EdgeInsets.only(
          left: withProgress ? 8.0 : 0.0,
        ),
        child: SandboxProgressIndicator(
          color: indicatorColor.withOpacity(isDisabled ? 0.6 : 1.0),
        ),
      ),
    );
  }

  static Color getButtonColor(
    BuildContext context, {
    bool isDisabled = false,
  }) {
    switch (context.watch<ThemeProvider>().type) {
      case ThemeStyleType.light: {
        return isDisabled
            ? ColorConstants.light.grey100.withOpacity(0.6)
            : ColorConstants.light.blue300;
      }

      case ThemeStyleType.dark: {
        return isDisabled
            ? ColorConstants.dark.grey100.withOpacity(0.6)
            : ColorConstants.dark.blue300;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isDisabled,
      child: Container(
        height: height,
        width: isSlim ? null : width ?? double.maxFinite,
        decoration: BoxDecoration(
          color: SandboxTextButton.getButtonColor(context, isDisabled: isDisabled),
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
