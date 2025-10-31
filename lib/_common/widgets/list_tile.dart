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

  Widget? _buildTitleWidget(BuildContext context) {
    if (title is String) {
      if (title == '') return null;
      return CustomText(
        text: title,
        style: options.titleStyle ?? Theme.of(context).textTheme.headlineSmall,
        isVerticalCentered: false,
      );
    }

    return title;
  }

  Widget? _buildSubtitleWidget(BuildContext context) {
    if (subtitle is String) {
      if (subtitle == '') return null;
      return CustomText(
        text: subtitle!,
        style: options.subtitleStyle ?? Theme.of(context).textTheme.bodyMedium,
        isVerticalCentered: false,
      );
    }

    return subtitle;
  }

  Widget _buildTitleAndSubtitleWidget(BuildContext context) {
    final titleWidget = _buildTitleWidget(context);
    final subtitleWidget = _buildSubtitleWidget(context);

    return Column(
      mainAxisAlignment: options.titleAndSubtitleAlignment,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (titleWidget != null)
          titleWidget,
        if (subtitleWidget != null) ...[
          SizedBox(height: options.titleIndent),
          subtitleWidget,
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorConstants.transparent,
      child: AbsorbPointer(
        absorbing: isDisabled,
        child: InkWell(
          onTap: onTap,
          borderRadius: options.borderRadius,
          child: Ink(
            height: options.height,
            padding: options.padding,
            decoration: BoxDecoration(
              border: options.border,
              borderRadius: options.borderRadius,
              color: options.backgroundColor,
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
                        SizedBox(width: options.leadingIndent),
                      ],
                      Expanded(
                        child: _buildTitleAndSubtitleWidget(context),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  SizedBox(width: options.trailingIndent),
                  trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomListTileOptions {
  final double? height;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final BoxBorder? border;
  final double titleIndent, leadingIndent, trailingIndent;
  final MainAxisAlignment titleAndSubtitleAlignment;
  final CrossAxisAlignment contentAlignment;
  final TextStyle? titleStyle, subtitleStyle;
  final Color? backgroundColor;

  const CustomListTileOptions({
    this.height,
    this.padding = const EdgeInsets.all(8.0),
    this.borderRadius = BorderRadius.zero,
    this.border,
    this.titleIndent = 4.0,
    this.leadingIndent = 16.0,
    this.trailingIndent = 16.0,
    this.titleAndSubtitleAlignment = MainAxisAlignment.center,
    this.contentAlignment = CrossAxisAlignment.center,
    this.titleStyle,
    this.subtitleStyle,
    this.backgroundColor,
  })  : assert(height == null || height >= 0),
        assert(titleIndent >= 0 && leadingIndent >= 0);
}