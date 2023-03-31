import 'package:flutter/material.dart';

import '../../constants/sizes.dart';
import 'texts.dart';

enum TileAxisAlignment {
  start,
  bottom,
  center,
}

class SandboxListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading, trailing;
  final VoidCallback? onCallback;
  final double height;
  final TextStyle? titleStyle, subtitleStyle;
  final double descriptionPadding, leadingPadding;
  final TileAxisAlignment contentAlignment;
  final Color? backgroundColor;
  final bool isDisabled;

  const SandboxListTile({
    Key? key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onCallback,
    this.height = SizeConstants.defaultListTileSize,
    this.titleStyle,
    this.subtitleStyle,
    this.descriptionPadding = 4.0,
    this.leadingPadding = 16.0,
    this.contentAlignment = TileAxisAlignment.center,
    this.backgroundColor,
    this.isDisabled = false,
  })  : assert(height >= 0),
        assert(descriptionPadding >= 0 && leadingPadding >= 0),
        super(key: key);

  Widget _buildDescriptionWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.values[contentAlignment.index],
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SandboxText(
          text: title,
        ),
        if (subtitle != null) ...[
          SizedBox(
            height: descriptionPadding,
          ),
          SandboxText(
            text: subtitle!,
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
        constraints: BoxConstraints(
          minHeight: height,
        ),
        color: backgroundColor,
        child: Row(
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onTap: onCallback,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.values[contentAlignment.index],
                  children: <Widget>[
                    if (leading != null) ...[
                      leading!,
                      SizedBox(
                        width: leadingPadding,
                      ),
                    ],
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: _buildDescriptionWidget(),
                      ),
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
