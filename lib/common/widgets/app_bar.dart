// ignore_for_file: deprecated_member_use

part of '../common.dart';

/// This is custom implementation of basic [AppBar] with morphing animation
/// Based on [MorphingAppBar] widget, to learn more visit https://pub.dev/packages/swipeable_page_route
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final dynamic content;
  final Widget? leading;
  final Widget? actions;
  final String? heroTag;
  @override
  final Size preferredSize;
  final EdgeInsets appBarPadding, contentPadding;
  final Widget? bottomContent;
  final bool withBackButton;
  final bool withElevation;
  final bool withShape;
  final bool isDisabled;
  final VoidCallback? onBackCallback;

  const CustomAppBar({
    super.key,
    this.content,
    this.leading,
    this.actions,
    this.heroTag,
    this.preferredSize = const Size.fromHeight(SizeConstants.defaultAppBarSize),
    this.appBarPadding = const EdgeInsets.only(left: 12.0, right: 8.0),
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 8.0),
    this.bottomContent,
    this.withBackButton = true,
    this.withElevation = true,
    this.withShape = false,
    this.isDisabled = false,
    this.onBackCallback,
  })  : assert(content is String || content is Widget || content == null);

  static CustomAppBar? fromScaffold(
    CustomAppBar? appBar, {
    required BuildContext context,
    bool isCanPop = true,
  }) {
    if (appBar == null) {
      return null;
    }

    return CustomAppBar(
      key: appBar.key,
      content: appBar.content,
      leading: appBar.leading,
      actions: appBar.actions,
      heroTag: appBar.heroTag,
      preferredSize: appBar.preferredSize,
      appBarPadding: appBar.appBarPadding,
      contentPadding: appBar.contentPadding,
      bottomContent: appBar.bottomContent,
      withBackButton: appBar.withBackButton,
      withElevation: appBar.withElevation,
      withShape: appBar.withShape,
      isDisabled: appBar.isDisabled,
      onBackCallback: isCanPop ? appBar.onBackCallback : () {},
    );
  }

  static Widget? buildContentWidget(dynamic content, BuildContext context) {
    assert(content is String || content is Widget || content == null);
    if (content is Widget) {
      return content;
    }

    if (content is String) {
      return CustomText(
        text: content,
        style: Theme.of(context).appBarTheme.titleTextStyle,
        maxLines: 2,
        isVerticalCentered: false,
      );
    }

    return null;
  }

  static Widget? buildLeadingWidget(
    Widget? leading,
    BuildContext context, {
    bool withBackButton = true,
    VoidCallback? onBackCallback,
  }) {
    if (leading != null) {
      return leading;
    }

    if (withBackButton) {
      return CustomIconButton(
        icon: SvgPicture.asset(
          ImageConstants.icBack,
        ),
        onCallback: onBackCallback ?? () => Navigator.of(context).pop(),
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final leadingWidget = CustomAppBar.buildLeadingWidget(
      leading,
      context,
      withBackButton: withBackButton,
      onBackCallback: onBackCallback,
    );

    return PreferredSize(
      preferredSize: preferredSize,
      child: OpacityWrapper(
        isOpaque: isDisabled,
        child: MorphingAppBar(
          heroTag: heroTag ?? 'MorphingAppBar',
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          shadowColor: Theme.of(context).appBarTheme.shadowColor,
          elevation: withElevation ? Theme.of(context).appBarTheme.elevation : 0.0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          toolbarHeight: preferredSize.height,
          titleSpacing: 0.0,
          title: Padding(
            padding: EdgeInsets.only(
              top: appBarPadding.top,
              bottom: appBarPadding.bottom,
              left: appBarPadding.left + ResponsiveWrapper.responsivePadding(context),
            ),
            child: Row(
              children: [
                if (leadingWidget != null) ...[
                  leadingWidget,
                  const SizedBox(
                    width: 8.0,
                  ),
                ],
                if (content != null)
                  Expanded(
                    child: Padding(
                      padding: contentPadding,
                      child: CustomAppBar.buildContentWidget(
                        content,
                        context,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            if (actions != null)
              Padding(
                padding: EdgeInsets.only(
                  top: appBarPadding.top,
                  bottom: appBarPadding.bottom,
                  right: appBarPadding.right + ResponsiveWrapper.responsivePadding(context),
                ),
                child: actions,
              ),
          ],
          bottom: bottomContent != null
              ? PreferredSize(
                  preferredSize: Size.zero,
                  child: bottomContent!,
                )
              : null,
          shape: withShape
              ? const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  ),
                )
              : null,
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
  final String? heroTag;
  @override
  final Size preferredSize;
  final EdgeInsets appBarPadding, contentPadding;
  final FlexibleSpaceBar? flexibleContent;
  final double? flexibleSize;

  /// You can use automatic responsive size calculator instead of setting const [flexibleSize] value
  /// Works well with static sized widgets, but can be some problematic with animated widgets
  /// If not null then the automatic calculator will work
  final GlobalKey? flexibleContentKey;
  final bool withBackButton;
  final bool withElevation;
  final bool withShape;
  final bool isBlocked;
  final VoidCallback? onBackCallback;

  const CustomSliverAppBar({
    super.key,
    this.content,
    this.leading,
    this.actions,
    this.heroTag,
    this.preferredSize = const Size.fromHeight(SizeConstants.defaultAppBarSize),
    this.appBarPadding = const EdgeInsets.only(left: 12.0, right: 8.0),
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 8.0),
    this.flexibleContent,
    this.flexibleSize,
    this.flexibleContentKey,
    this.withBackButton = true,
    this.withElevation = true,
    this.withShape = true,
    this.isBlocked = false,
    this.onBackCallback,
  })  : assert(content is String || content is Widget || content == null),
        assert(flexibleSize != null || flexibleContentKey != null);

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

  void _handleFlexibleContentSize(_) {
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
      context,
      withBackButton: widget.withBackButton,
      onBackCallback: widget.onBackCallback,
    );

    return PreferredSize(
      preferredSize: widget.preferredSize,
      child: MorphingSliverAppBar(
        heroTag: widget.heroTag ?? 'MorphingAppBar',
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        shadowColor: Theme.of(context).appBarTheme.shadowColor,
        elevation: widget.withElevation ? Theme.of(context).appBarTheme.elevation : 0.0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        pinned: true,
        titleSpacing: 0.0,
        toolbarHeight: widget.preferredSize.height,
        collapsedHeight: widget.preferredSize.height,
        expandedHeight: widget.preferredSize.height + (widget.flexibleSize ?? _flexibleSize),
        title: Container(
          height: widget.preferredSize.height,
          padding: EdgeInsets.only(
            top:  widget.appBarPadding.top,
            bottom: widget.appBarPadding.bottom,
            left: widget.appBarPadding.left,
          ),
          color: Theme.of(context).appBarTheme.backgroundColor,
          child: Row(
            children: [
              if (leadingWidget != null) ...[
                leadingWidget,
                const SizedBox(
                  width: 8.0,
                ),
              ],
              if (widget.content != null)
                Expanded(
                  child: Padding(
                    padding: widget.contentPadding,
                    child: CustomAppBar.buildContentWidget(
                      widget.content,
                      context,
                    ),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          if (widget.actions != null)
            Padding(
              padding: EdgeInsets.only(
                top: widget.appBarPadding.top,
                bottom: widget.appBarPadding.bottom,
                right: widget.appBarPadding.right,
              ),
              child: widget.actions,
            ),
        ],
        flexibleSpace: SafeArea(
          child: widget.flexibleContent as Widget,
        ),
        shape: widget.withShape
            ? const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0),
                ),
              )
            : null,
      ),
    );
  }
}
