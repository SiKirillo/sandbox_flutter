part of 'in_app_slider_provider.dart';

class InAppSlider extends StatefulWidget {
  final List<InAppSliderData> data;
  final TextStyle? labelStyle, descriptionStyle;
  final double? iconHeight;
  final double iconIndent, textIndent, dashIndent;
  final bool enableInfiniteScroll;
  final bool autoPlay;
  final Duration autoPlayInterval;

  const InAppSlider({
    super.key,
    required this.data,
    this.labelStyle,
    this.descriptionStyle,
    this.iconHeight,
    this.iconIndent = 6.0,
    this.textIndent = 16.0,
    this.dashIndent = 40.0,
    this.enableInfiniteScroll = true,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 5),
  });

  static final controller = CarouselSliderController();

  @override
  State<InAppSlider> createState() => _HowToUseSliderState();
}

class _HowToUseSliderState extends State<InAppSlider> {
  int _selectedPage = 0;

  @override
  void initState() {
    super.initState();
    locator<InAppSliderProvider>().init(
      initialPage: _selectedPage,
      maxPage: widget.data.length - 1,
    );
  }

  void _onPageChangedHandler(int index, CarouselPageChangedReason reason) {
    setState(() {
      _selectedPage = index;
      locator<InAppSliderProvider>().update(currentPage: index);
    });
  }

  double _getLabelMaxSize(double maxWidth) {
    final maxLabel = widget.data.map((item) => item.label).toList()..sort((a, b) => b.length.compareTo(a.length));
    final maxDescription = widget.data.map((item) => item.description).toList()..sort((a, b) => b.length.compareTo(a.length));

    final labelStyle = widget.labelStyle ?? Theme.of(context).textTheme.headlineLarge;
    final descriptionStyle = widget.descriptionStyle ?? Theme.of(context).textTheme.bodyMedium;

    final labelPainter = TextPainter(
      text: TextSpan(
        text: maxLabel.first,
        style: labelStyle,
      ),
      maxLines: 2,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    final descriptionPainter = TextPainter(
      text: TextSpan(
        text: maxDescription.first,
        style: descriptionStyle,
      ),
      maxLines: 5,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    double additionalIndent = 0.0;
    const isVerticalCentered = true;
    if (isVerticalCentered) {
      final bottomLabelPadding = ((labelStyle?.height ?? 1.0) * (labelStyle?.fontSize ?? 14.0) - (labelStyle?.fontSize ?? 14.0)) / 2.0;
      final bottomDescriptionPadding = ((descriptionStyle?.height ?? 1.0) * (descriptionStyle?.fontSize ?? 14.0) - (descriptionStyle?.fontSize ?? 14.0)) / 2.0;
      additionalIndent = bottomLabelPadding + bottomDescriptionPadding;
    }

    return labelPainter.height + descriptionPainter.height + widget.textIndent + additionalIndent;
  }

  void _onHorizontalDragUpdateHandler(DragUpdateDetails details) {
    if (details.delta.dx >= 8.0) {
      InAppSlider.controller.previousPage(curve: Curves.fastOutSlowIn);
    } else if (details.delta.dx <= -8.0) {
      InAppSlider.controller.nextPage(curve: Curves.fastOutSlowIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onHorizontalDragUpdate: _onHorizontalDragUpdateHandler,
          child: Container(
            color: ColorConstants.transparent,
            child: Column(
              children: [
                SizedBox(
                  height: widget.iconHeight,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CarouselSlider(
                          carouselController: InAppSlider.controller,
                          options: CarouselOptions(
                            viewportFraction: 1.0,
                            scrollPhysics: StyleConstants.disableScrollPhysics,
                            onPageChanged: _onPageChangedHandler,
                            enableInfiniteScroll: widget.enableInfiniteScroll,
                            autoPlay: widget.autoPlay,
                            autoPlayInterval: widget.autoPlayInterval,
                          ),
                          items: widget.data.map((item) {
                            return item.iconSrc.contains(ImageConstants.svgPrefix)
                                ? SvgPicture.asset(item.iconSrc)
                                : Image.asset(item.iconSrc);
                          }).toList(),
                        ),
                      ),
                      Positioned(
                        top: 0.0,
                        bottom: 0.0,
                        left: 0.0,
                        width: 20.0,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: ColorConstants.scaffoldGradientOpacity().reversed.toList(),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0.0,
                        bottom: 0.0,
                        right: 0.0,
                        width: 20.0,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: ColorConstants.scaffoldGradientOpacity(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: widget.iconIndent,
                ),
                LayoutBuilder(
                  builder: (_, constraints) {
                    return Container(
                      height: _getLabelMaxSize(constraints.maxWidth - 16.0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      child: AnimatedSwitcher(
                        duration: StyleConstants.defaultAnimationDuration,
                        child: Column(
                          key: ValueKey(_selectedPage),
                          children: [
                            CustomText(
                              text: widget.data[_selectedPage].label,
                              style: widget.labelStyle ?? Theme.of(context).textTheme.headlineLarge,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                            SizedBox(
                              height: widget.textIndent,
                            ),
                            CustomText(
                              text: widget.data[_selectedPage].description,
                              style: widget.descriptionStyle ?? Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                              maxLines: 5,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: widget.dashIndent,
                ),
              ],
            ),
          ),
        ),
        DashNavigator(
          number: _selectedPage,
          total: widget.data.length,
        ),
      ],
    );
  }
}