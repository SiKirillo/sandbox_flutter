import 'package:flutter/material.dart';

import '../../constants/sizes.dart';
import 'texts.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading, trailing;
  final VoidCallback? onCallback;
  final double height;
  final TextStyle? titleStyle, subtitleStyle;
  final EdgeInsets padding;
  final double descriptionIndent, leadingIndent;
  final MainAxisAlignment descriptionAlignment;
  final CrossAxisAlignment contentAlignment;
  final Color? backgroundColor;
  final bool isDisabled;

  const CustomListTile({
    Key? key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onCallback,
    this.height = SizeConstants.defaultListTileSize,
    this.titleStyle,
    this.subtitleStyle,
    this.padding = const EdgeInsets.all(8.0),
    this.descriptionIndent = 4.0,
    this.leadingIndent = 16.0,
    this.descriptionAlignment = MainAxisAlignment.center,
    this.contentAlignment = CrossAxisAlignment.center,
    this.backgroundColor,
    this.isDisabled = false,
  })  : assert(height >= 0),
        assert(descriptionIndent >= 0 && leadingIndent >= 0),
        super(key: key);

  Widget _buildDescriptionWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: descriptionAlignment,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomText(
          text: title,
          style: titleStyle,
        ),
        if (subtitle != null) ...[
          SizedBox(
            height: descriptionIndent,
          ),
          CustomText(
            text: subtitle!,
            style: subtitleStyle,
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isDisabled,
      child: Container(
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          color: backgroundColor ?? Theme.of(context).listTileTheme.tileColor,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onTap: onCallback,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: contentAlignment,
                  children: <Widget>[
                    if (leading != null) ...[
                      leading!,
                      SizedBox(
                        width: leadingIndent,
                      ),
                    ],
                    Expanded(
                      child: _buildDescriptionWidget(context),
                    ),
                  ],
                ),
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(
                width: 16.0,
              ),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
