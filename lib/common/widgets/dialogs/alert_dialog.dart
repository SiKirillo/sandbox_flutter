import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../texts.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final dynamic content;
  final String cancelText, actionText;
  final VoidCallback onCancel, onAction;
  final bool isDisabled;

  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.cancelText,
    required this.actionText,
    required this.onCancel,
    required this.onAction,
    this.isDisabled = false,
  })  : assert(content is String || content is Widget),
        super(key: key);

  Widget _buildMaterialDialog(BuildContext context) {
    return AlertDialog(
      title: CustomText(
        text: title,
        style: Theme.of(context).dialogTheme.titleTextStyle,
      ),
      content: content is Widget
          ? content
          : CustomText(
              text: content!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: CustomText(
            text: cancelText.toUpperCase(),
            maxLines: 1,
          ),
        ),
        TextButton(
          onPressed: onAction,
          child: CustomText(
            text: actionText.toUpperCase(),
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildCupertinoDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            text: title,
            style: const TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              height: 22.0 / 16.0,
              color: ColorConstants.transparent,
            ),
          ),
        ],
      ),
      content: content is Widget
          ? content
          : CustomText(
              text: content!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontFamily: 'OpenSans',
                height: 18.0 / 13.0,
                color: ColorConstants.transparent,
              ),
              textAlign: TextAlign.center,
            ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: CustomText(
            text: cancelText,
            style: const TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              height: 22.0 / 16.0,
            ),
            maxLines: 1,
          ),
        ),
        TextButton(
          onPressed: onAction,
          child: CustomText(
            text: actionText,
            style: const TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              height: 22.0 / 16.0,
            ),
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !isDisabled;
      },
      child: AbsorbPointer(
        absorbing: isDisabled,
        child: Platform.isAndroid
            ? _buildMaterialDialog(context)
            : _buildCupertinoDialog(context),
      ),
    );
  }
}
