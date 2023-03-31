import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import '../../constants/sizes.dart';
import 'texts.dart';
import 'wrappers/opacity_wrapper.dart';
import 'wrappers/scrollable_wrapper.dart';

/// This is custom implementation of basic [AppBar] with morphing animation
/// Based on [MorphingAppBar] widget, to learn more visit https://pub.dev/packages/swipeable_page_route
class SandboxAppBar extends StatelessWidget implements PreferredSizeWidget {
  final dynamic content;
  final Widget? leading;
  final Widget? actions;
  final String? heroTag;
  @override
  final Size preferredSize;
  final EdgeInsets appBarPadding, contentPadding;
  final bool withBackButton;
  final bool withElevation;
  final bool isDisabled;
  final VoidCallback? onBackCallback;

  const SandboxAppBar({
    Key? key,
    this.content,
    this.leading,
    this.actions,
    this.heroTag,
    this.preferredSize = const Size.fromHeight(SizeConstants.defaultAppBarSize),
    this.appBarPadding = const EdgeInsets.symmetric(horizontal: 24.0),
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.withBackButton = true,
    this.withElevation = true,
    this.isDisabled = false,
    this.onBackCallback,
  })  : assert(content is String || content is Widget || content == null),
        super(key: key);

  static Widget? buildContentWidget(dynamic content, BuildContext context) {
    assert(content is String || content is Widget || content == null);
    if (content is Widget) {
      return content;
    }

    if (content is String) {
      return SandboxText(
        text: content,
        style: Theme.of(context).appBarTheme.titleTextStyle,
        maxLines: 2,
        textAlign: TextAlign.center,
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
      return GestureDetector(
        onTap: onBackCallback ?? () => Navigator.of(context).pop(),
        child: const SizedBox.square(
          dimension: 40.0,
          child: Icon(
            Icons.arrow_back_outlined,
            size: 28.0,
          ),
        ),
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
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
            padding: appBarPadding,
            child: Row(
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SandboxAppBar.buildLeadingWidget(
                      leading,
                      context,
                      withBackButton: withBackButton,
                      onBackCallback: onBackCallback,
                    ) ?? const SizedBox(),
                  ),
                ),
                if (content != null)
                  Flexible(
                    flex: 4,
                    child: Center(
                      child: Padding(
                        padding: contentPadding,
                        child: SandboxAppBar.buildContentWidget(content, context),
                      ),
                    ),
                  ),
                Flexible(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: actions ?? const SizedBox(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// This is custom implementation of basic [SliverAppBar] with morphing animation
/// Used only in some scrollable widgets like [ScrollableWrapper]
/// Based on [MorphingSliverAppBar] widget, to learn more visit https://pub.dev/packages/swipeable_page_route
class SandboxSliverAppBar extends StatefulWidget implements PreferredSizeWidget {
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
  final bool isBlocked;
  final VoidCallback? onBackCallback;

  const SandboxSliverAppBar({
    Key? key,
    this.content,
    this.leading,
    this.actions,
    this.heroTag,
    this.preferredSize = const Size.fromHeight(SizeConstants.defaultAppBarSize),
    this.appBarPadding = const EdgeInsets.symmetric(horizontal: 24.0),
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.flexibleContent,
    this.flexibleSize,
    this.flexibleContentKey,
    this.withBackButton = true,
    this.withElevation = true,
    this.isBlocked = false,
    this.onBackCallback,
  })  : assert(content is String || content is Widget || content == null),
        assert(flexibleSize != null && flexibleContentKey != null),
        super(key: key);

  @override
  State<SandboxSliverAppBar> createState() => _SandboxSliverAppBarState();
}

class _SandboxSliverAppBarState extends State<SandboxSliverAppBar> with WidgetsBindingObserver {
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
  void didUpdateWidget(covariant SandboxSliverAppBar oldWidget) {
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
        title: Padding(
          padding: widget.appBarPadding,
          child: Row(
            children: [
              Flexible(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SandboxAppBar.buildLeadingWidget(
                    widget.leading,
                    context,
                    withBackButton: widget.withBackButton,
                    onBackCallback: widget.onBackCallback,
                  ) ?? const SizedBox(),
                ),
              ),
              if (widget.content != null)
                Flexible(
                  flex: 4,
                  child: Center(
                    child: Padding(
                      padding: widget.contentPadding,
                      child: SandboxAppBar.buildContentWidget(widget.content, context),
                    ),
                  ),
                ),
              Flexible(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: widget.actions ?? const SizedBox(),
                ),
              ),
            ],
          ),
        ),
        flexibleSpace: widget.flexibleContent,
      ),
    );
  }
}
