import 'package:flutter/material.dart';

import '../../../constants/images.dart';
import '../../../constants/sizes.dart';
import '../texts.dart';
import 'opacity_wrapper.dart';

/// You can wrap all your bottom sheet widgets in this widget to have more control
class DialogWrapper extends StatelessWidget {
  final Widget child;
  /// There are label and description which are above your child widget
  final dynamic label, description;
  final TextStyle? labelStyle, descriptionStyle;
  final EdgeInsets contentPadding, closeButtonPadding;
  /// This is space between a dialog label and your child widget
  final double contentIndent;
  final bool withCloseButton;
  /// This is a padding of your child widget
  final bool withPadding;
  final bool isDisabled;
  final bool isHidden;

  const DialogWrapper({
    Key? key,
    required this.child,
    this.label,
    this.description,
    this.labelStyle,
    this.descriptionStyle,
    this.contentPadding = const EdgeInsets.only(
      top: 30.0,
      bottom: 24.0,
      left: 24.0,
      right: 24.0,
    ),
    this.closeButtonPadding = const EdgeInsets.all(12.0),
    this.contentIndent = 32.0,
    this.withCloseButton = false,
    this.withPadding = true,
    this.isDisabled = false,
    this.isHidden = false,
  })  : assert(label is String || label is Widget || label == null),
        assert(description is String || description is Widget || description == null),
        assert(contentIndent >= 0),
        super(key: key);

  static const _onShowDuration = Duration(milliseconds: 200);
  static const _onHideDuration = Duration(milliseconds: 250);

  Future<void> _closeButtonHandler(BuildContext context) async {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop();
  }

  Widget _buildDialogWrapperWidget(BuildContext context) {
    final labelContent = label is Widget
        ? label
        : label is String
            ? CustomText(
                text: label!,
                style: labelStyle ?? Theme.of(context).dialogTheme.titleTextStyle,
                textAlign: TextAlign.center,
              )
            : null;

    final descriptionContent = description is Widget
        ? description
        : description is String
            ? CustomText(
                text: description!,
                style: descriptionStyle,
                textAlign: TextAlign.center,
              )
            : null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        OpacityWrapper(
          isOpaque: isDisabled,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: contentPadding.top,
                  left: contentPadding.left,
                  right: contentPadding.right,
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
        ),
        SizedBox(
          height: contentIndent,
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
    return AbsorbPointer(
      absorbing: isDisabled,
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
    );
  }
}
