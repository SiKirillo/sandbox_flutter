part of '../common.dart';

/// This is custom implementation of basic [AppBar] with morphing animation
/// Based on [MorphingAppBar] widget, to learn more visit https://pub.dev/packages/swipeable_page_route
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final dynamic content;
  final Widget? leading;
  final Widget? actions;
  final Widget? bottomContent;
  final VoidCallback? onGoBack;
  @override
  final Size preferredSize;
  final CustomAppBarOptions options;
  final bool isDisabled;

  const CustomAppBar({
    super.key,
    this.content,
    this.leading,
    this.actions,
    this.bottomContent,
    this.onGoBack,
    this.preferredSize = const Size.fromHeight(SizeConstants.defaultAppBarSize),
    this.options = const CustomAppBarOptions(),
    this.isDisabled = false,
  }) : assert(content is String || content is Widget || content == null);

  static Widget? buildContentWidget(
    dynamic content, {
    required BuildContext context,
    CustomAppBarOptions? options,
  }) {
    assert(content is String || content is Widget || content == null);
    if (content is String) {
      return CustomText(
        text: content,
        style: options?.contentStyle ?? Theme.of(context).appBarTheme.titleTextStyle,
        textAlign: options?.textAlign ?? TextAlign.start,
        maxLines: 2,
        isVerticalCentered: false,
      );
    }

    return content;
  }

  static Widget? buildLeadingWidget(
    Widget? leading, {
    required BuildContext context,
    VoidCallback? onBackCallback,
    CustomAppBarOptions? options,
  }) {
    if (options?.withBackButton == true) {
      return CustomIconButton(
        content: SvgPicture.asset(
          ImageConstants.icBack,
          colorFilter: options?.iconColor != null
              ? ColorFilter.mode(options!.iconColor!, BlendMode.srcIn)
              : null,
        ),
        onTap: onBackCallback ?? () => Navigator.of(context).pop(),
        options: CustomButtonOptions(
          size: 40.0,
          padding: EdgeInsets.zero,
        ),
      );
    }

    if (options?.withCloseButton == true) {
      return CustomIconButton(
        content: SvgPicture.asset(
          ImageConstants.icClose,
          colorFilter: options?.iconColor != null
              ? ColorFilter.mode(options!.iconColor!, BlendMode.srcIn)
              : null,
        ),
        onTap: onBackCallback ?? () => Navigator.of(context).pop(),
        options: CustomButtonOptions(
          size: 24.0,
          padding: EdgeInsets.zero,
        ),
      );
    }

    return leading;
  }

  @override
  Widget build(BuildContext context) {
    final leadingWidget = CustomAppBar.buildLeadingWidget(
      leading,
      context: context,
      onBackCallback: onGoBack,
      options: options,
    );

    /// You can use MorphingAppBar after plugin fix compilation with flutter 3.35+ with heroTag: options.heroTag
    return PreferredSize(
      preferredSize: preferredSize,
      child: OpacityWrapper(
        isOpaque: isDisabled,
        child: AppBar(
          // heroTag: options.heroTag,
          backgroundColor: options.backgroundColor ?? Theme.of(context).appBarTheme.backgroundColor,
          shadowColor: options.shadowColor ?? Theme.of(context).appBarTheme.shadowColor,
          elevation: options.withElevation ? Theme.of(context).appBarTheme.elevation : 0.0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          toolbarHeight: preferredSize.height,
          titleSpacing: 0.0,
          title: Padding(
            padding: options.appBarPadding,
            child: Row(
              crossAxisAlignment: options.appBarAlign,
              children: [
                if (leadingWidget != null)
                  leadingWidget,
                Expanded(
                  child: Padding(
                    padding: options.contentPadding,
                    child: CustomAppBar.buildContentWidget(
                      content,
                      context: context,
                      options: options,
                    ),
                  ),
                ),
                if (actions != null)
                  actions!,
              ],
            ),
          ),
          bottom: bottomContent != null
              ? PreferredSize(
                  preferredSize: Size.zero,
                  child: bottomContent!,
                )
              : null,
          shape: options.withDivider
              ? Border(
                  bottom: BorderSide(
                    color: ColorConstants.appBarDivider(),
                    width: 1.0,
                  ),
                )
              : RoundedRectangleBorder(
                  borderRadius: options.borderRadius ?? BorderRadius.zero,
                ),
        ),
      ),
    );
  }
}

/// This is custom implementation of basic [SliverAppBar] with morphing animation
/// Used only in some scrollable widgets like [ScrollableWrapper]
/// Based on [MorphingSliverAppBar] widget, to learn more visit https://pub.dev/packages/swipeable_page_route
class CustomSliverAppBar extends StatefulWidget implements PreferredSizeWidget {
  final dynamic content;
  final Widget? leading;
  final Widget? actions;
  final VoidCallback? onGoBack;
  @override
  final Size preferredSize;
  final CustomAppBarOptions options;

  /// You can use automatic responsive size calculator instead of setting const [flexibleSize] value
  /// Works well with static sized widgets, but can be some problematic with animated widgets
  /// If not null then the automatic calculator will work
  final GlobalKey? flexibleContentKey;
  final FlexibleSpaceBar? flexibleContent;
  final double? flexibleSize;
  final bool isDisabled;

  const CustomSliverAppBar({
    super.key,
    this.content,
    this.leading,
    this.actions,
    this.onGoBack,
    this.preferredSize = const Size.fromHeight(SizeConstants.defaultAppBarSize),
    this.options = const CustomAppBarOptions(),
    this.flexibleContentKey,
    this.flexibleContent,
    this.flexibleSize,
    this.isDisabled = false,
  }) : assert(content is String || content is Widget || content == null);

  @override
  State<CustomSliverAppBar> createState() => _CustomSliverAppBarState();
}

class _CustomSliverAppBarState extends State<CustomSliverAppBar> with WidgetsBindingObserver {
  double _flexibleSize = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.flexibleContentKey != null && widget.flexibleContent != null) {
      WidgetsBinding.instance.addPostFrameCallback(_handleFlexibleContentSize);
    }
  }

  @override
  void didUpdateWidget(covariant CustomSliverAppBar oldWidget) {
    if (widget.flexibleContentKey != null && widget.flexibleContent != null) {
      WidgetsBinding.instance.addPostFrameCallback(_handleFlexibleContentSize);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _handleFlexibleContentSize(void _) {
    final flexibleContext = widget.flexibleContentKey?.currentContext;
    if (flexibleContext == null) {
      return;
    }

    final previousSize = _flexibleSize;
    final newSize = flexibleContext.size!.height;

    if (mounted && previousSize != newSize) {
      setState(() {
        _flexibleSize = newSize;
      });

      WidgetsBinding.instance.addPostFrameCallback(_handleFlexibleContentSize);
    }
  }

  @override
  Widget build(BuildContext context) {
    final leadingWidget = CustomAppBar.buildLeadingWidget(
      widget.leading,
      context: context,
      onBackCallback: widget.onGoBack,
      options: widget.options,
    );

    /// You can use MorphingSliverAppBar after plugin fix compilation with flutter 3.35+ with heroTag: options.heroTag
    return PreferredSize(
      preferredSize: widget.preferredSize,
      child: SliverAppBar(
        // heroTag: widget.options.heroTag,
        backgroundColor: widget.options.backgroundColor ?? Theme.of(context).appBarTheme.backgroundColor,
        shadowColor: widget.options.shadowColor ?? Theme.of(context).appBarTheme.shadowColor,
        elevation: widget.options.withElevation ? Theme.of(context).appBarTheme.elevation : 0.0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        pinned: true,
        titleSpacing: 0.0,
        toolbarHeight: widget.preferredSize.height,
        collapsedHeight: widget.preferredSize.height,
        expandedHeight: widget.preferredSize.height + (widget.flexibleSize ?? _flexibleSize),
        title: Container(
          height: widget.preferredSize.height,
          padding: EdgeInsets.fromLTRB(
            widget.options.appBarPadding.left + ResponsiveWrapper.responsivePadding(context),
            widget.options.appBarPadding.top,
            widget.options.appBarPadding.right + ResponsiveWrapper.responsivePadding(context),
            widget.options.appBarPadding.bottom,
          ),
          decoration: BoxDecoration(
            borderRadius: widget.options.borderRadius,
            color: widget.options.backgroundColor ?? Theme.of(context).appBarTheme.backgroundColor,
          ),
          child: Row(
            crossAxisAlignment: widget.options.appBarAlign,
            children: [
              if (leadingWidget != null)
                leadingWidget,
              Expanded(
                child: Padding(
                  padding: widget.options.contentPadding,
                  child: CustomAppBar.buildContentWidget(
                    widget.content,
                    context: context,
                    options: widget.options,
                  ),
                ),
              ),
              if (widget.actions != null)
                widget.actions!,
            ],
          ),
        ),
        flexibleSpace: widget.flexibleContent != null ? SafeArea(
          child: ClipRRect(
            borderRadius: widget.options.borderRadius ?? BorderRadius.zero,
            child: Stack(
              children: [
                widget.flexibleContent as Widget,
                Positioned(
                  top: widget.preferredSize.height - 16.0,
                  left: 0.0,
                  right: 0.0,
                  child: CustomScrollOpacityGradient(
                    size: 4.0 + 16.0,
                    colors: [
                      widget.options.backgroundColor,
                      widget.options.backgroundColor?.withValues(alpha: 0.0),
                    ],
                    stops: [0.8, 1.0],
                  ),
                ),
              ],
            ),
          ),
        ) : null,
        shape: widget.options.withDivider
            ? Border(
                bottom: BorderSide(
                  color: ColorConstants.appBarDivider(),
                  width: 1.0,
                ),
              )
            : RoundedRectangleBorder(
                borderRadius: widget.options.borderRadius ?? BorderRadius.zero,
              ),
      ),
    );
  }
}

class CustomAppBarOptions {
  final String heroTag;
  final EdgeInsets appBarPadding, contentPadding;
  final BorderRadius? borderRadius;
  final CrossAxisAlignment appBarAlign;
  final TextStyle? contentStyle;
  final TextAlign textAlign;
  final bool withBackButton;
  final bool withCloseButton;
  final bool withElevation;
  final bool withDivider;
  final Color? backgroundColor, shadowColor;
  final Color? iconColor;

  const CustomAppBarOptions({
    this.heroTag = 'MorphingAppBar',
    this.appBarPadding = const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
    this.contentPadding = const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
    this.borderRadius,
    this.appBarAlign = CrossAxisAlignment.center,
    this.contentStyle,
    this.textAlign = TextAlign.center,
    this.withBackButton = true,
    this.withCloseButton = false,
    this.withElevation = true,
    this.withDivider = false,
    this.backgroundColor,
    this.shadowColor,
    this.iconColor,
  });
}