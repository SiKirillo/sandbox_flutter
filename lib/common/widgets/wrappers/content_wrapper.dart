import 'package:flutter/material.dart';
import '../../../constants/sizes.dart';
import 'dialog_wrapper.dart';

/// You can wrap all your screens in this widget to control padding
/// If you want to use bottom sheets try [DialogWrapper]
class ContentWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final bool withSafeAreaResize;
  final bool withKeyboardResize;

  const ContentWrapper({
    super.key,
    required this.child,
    this.padding = ContentWrapper.defaultPadding,
    this.withSafeAreaResize = true,
    this.withKeyboardResize = true,
  });

  static const defaultPadding = EdgeInsets.all(SizeConstants.defaultPadding);

  @override
  Widget build(BuildContext context) {
    final safeAreaInsets = withSafeAreaResize
        ? MediaQuery.of(context).viewPadding.top
        : 0.0;
    final keyboardInsets = withKeyboardResize
        ? MediaQuery.of(context).viewInsets.bottom
        : 0.0;

    return Padding(
      padding: EdgeInsets.only(
        top: padding.top + safeAreaInsets,
        bottom: padding.bottom + keyboardInsets,
        left: padding.left,
        right: padding.right,
      ),
      child: child,
    );
  }
}
