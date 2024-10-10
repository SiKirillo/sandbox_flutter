part of '../common.dart';

class CustomListTile extends StatelessWidget {
  final dynamic title, subtitle;
  final Widget? leading, trailing;
  final VoidCallback? onTap;
  final bool isDisabled;
  final CustomListTileOptions options;

  const CustomListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.isDisabled = false,
    this.options = const CustomListTileOptions(),
  })  : assert(title is String || title is Widget),
        assert(subtitle is String || subtitle is Widget || subtitle == null);

  Widget _buildTitleAndSubtitleWidget(BuildContext context) {
    final titleContent = title is Widget
        ? title
        : CustomText(
            text: title,
            style: options.titleStyle ?? Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            isVerticalCentered: false,
          );

    final subtitleContent = subtitle is Widget
        ? subtitle
        : subtitle is String
            ? CustomText(
                text: subtitle!,
                style: options.subtitleStyle ?? Theme.of(context).textTheme.bodyMedium,
                isVerticalCentered: false,
              )
            : null;

    return Column(
      mainAxisAlignment: options.titleAndSubtitleAlignment,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        titleContent,
        if (subtitleContent != null) ...[
          SizedBox(
            height: options.titleAndSubtitleIndent,
          ),
          subtitleContent,
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isDisabled,
      child: InkWell(
        onTap: onTap,
        borderRadius: options.borderRadius,
        child: Ink(
          height: options.height,
          padding: options.padding,
          decoration: BoxDecoration(
            borderRadius: options.borderRadius,
            color: options.backgroundColor ?? Theme.of(context).listTileTheme.tileColor,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: options.contentAlignment,
                  children: <Widget>[
                    if (leading != null) ...[
                      leading!,
                      SizedBox(
                        width: options.leadingIndent,
                      ),
                    ],
                    Expanded(
                      child: _buildTitleAndSubtitleWidget(context),
                    ),
                  ],
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
      ),
    );
  }
}

class CustomListTileOptions {
  final double height;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final double titleAndSubtitleIndent, leadingIndent;
  final MainAxisAlignment titleAndSubtitleAlignment;
  final CrossAxisAlignment contentAlignment;
  final TextStyle? titleStyle, subtitleStyle;
  final Color? backgroundColor;

  const CustomListTileOptions({
    this.height = SizeConstants.defaultListTileSize,
    this.padding = const EdgeInsets.all(8.0),
    this.borderRadius = const BorderRadius.all(Radius.circular(10.0)),
    this.titleAndSubtitleIndent = 4.0,
    this.leadingIndent = 16.0,
    this.titleAndSubtitleAlignment = MainAxisAlignment.center,
    this.contentAlignment = CrossAxisAlignment.center,
    this.titleStyle,
    this.subtitleStyle,
    this.backgroundColor,
  })  : assert(height >= 0),
        assert(titleAndSubtitleIndent >= 0 && leadingIndent >= 0);
}