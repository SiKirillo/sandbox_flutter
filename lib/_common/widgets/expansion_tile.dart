part of '../common.dart';

class CustomExpansionTitle extends StatefulWidget {
  final dynamic label;
  final dynamic content;
  final ValueChanged<bool>? onTap;
  final CustomExpansionTitleOptions options;
  final bool isExpanded;
  final bool isDisabled;

  const CustomExpansionTitle({
    super.key,
    required this.label,
    required this.content,
    this.onTap,
    this.options = const CustomExpansionTitleOptions(),
    this.isExpanded = false,
    this.isDisabled = false,
  })  : assert(label is Widget || label is String),
        assert(content is Widget || content is String);

  @override
  State<CustomExpansionTitle> createState() => _CustomExpansionTitleState();
}

class _CustomExpansionTitleState extends State<CustomExpansionTitle> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final CurvedAnimation _heightFactor;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    _heightFactor = CurvedAnimation(
      parent: _animationController.drive(Tween<double>(begin: 0.0, end: 1.0)),
      curve: Curves.easeIn,
    );

    _isExpanded = PageStorage.maybeOf(context)?.readState(context) as bool? ?? widget.isExpanded;
    if (_isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant CustomExpansionTitle oldWidget) {
    if (widget.isExpanded != _isExpanded) {
      _onToggleExpansionHandler(withCallback: false);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _heightFactor.dispose();
    super.dispose();
  }

  void _onToggleExpansionHandler({bool withCallback = true}) {
    _isExpanded = !_isExpanded;
    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    }

    setState(() {});
    PageStorage.maybeOf(context)?.writeState(context, _isExpanded);

    if (withCallback) {
      widget.onTap?.call(_isExpanded);
    }
  }

  Widget _buildLabelWidget() {
    if (widget.label is String) {
      final textStyle = widget.options.buttonTextStyle ?? Theme.of(context).textTheme.displayMedium;
      return CustomText(
        text: widget.label,
        style: textStyle,
        maxLines: 100,
        isVerticalCentered: false,
      );
    }

    return widget.label;
  }

  Widget _buildContentWidget() {
    if (widget.content is String) {
      final textStyle = widget.options.contentTextStyle ?? Theme.of(context).textTheme.displayMedium;
      return CustomText(
        text: widget.content,
        style: textStyle,
        maxLines: 100,
        isVerticalCentered: false,
      );
    }

    return widget.content;
  }

  Widget _buildExpansionButton(BuildContext context, Widget? child) {
    return Stack(
      children: [
        Positioned.fill(
          top: 12.0,
          child: Container(
            decoration: BoxDecoration(
              color: widget.options.contentColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12.0),
                bottomRight: Radius.circular(12.0),
              ),
            ),
          ),
        ),
        ScrollableWrapper(
          options: ScrollableWrapperOptions(
            type: ScrollableWrapperType.dialog,
            padding: EdgeInsets.zero,
            isScrollEnabled: false,
          ),
          child: Column(
            children: [
              CustomButton(
                content: _buildLabelWidget(),
                onTap: _onToggleExpansionHandler,
                options: CustomButtonOptions(
                  height: null,
                  constraints: BoxConstraints(
                    minHeight: SizeConstants.defaultButtonHeight,
                  ),
                  padding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
                  color: widget.options.buttonColor,
                ),
                isDisabled: widget.isDisabled,
              ),
              ClipRRect(
                child: Align(
                  heightFactor: _heightFactor.value,
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHiddenDescription(bool icClosed) {
    return Offstage(
      offstage: icClosed,
      child: TickerMode(
        enabled: !icClosed,
        child: Padding(
          padding: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
          child: Row(
            children: [
              Flexible(
                child: _buildContentWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final icClosed = !_isExpanded && _animationController.isDismissed;
    final isShouldRemove = icClosed && !widget.options.withMaintainState;
    final hiddenWidget = _buildHiddenDescription(icClosed);

    return AnimatedBuilder(
      animation: _animationController.view,
      builder: _buildExpansionButton,
      child: isShouldRemove ? null : hiddenWidget,
    );
  }
}

class CustomExpansionTitleOptions {
  final bool withMaintainState;
  final Color? buttonColor, contentColor;
  final TextStyle? buttonTextStyle, contentTextStyle;

  const CustomExpansionTitleOptions({
    this.withMaintainState = false,
    this.buttonColor,
    this.contentColor,
    this.buttonTextStyle,
    this.contentTextStyle,
  });
}