part of '../common.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final bool softWrap;
  final TextOverflow overflow;
  final int? maxLines;
  final double? textScaleFactor;
  final TextWidthBasis? textWidthBasis;

  /// Flutter engine does not support text vertical alignment.
  /// This is custom solution for that
  final bool isVerticalCentered;

  const CustomText({
    super.key,
    required this.text,
    this.style,
    this.textAlign = TextAlign.start,
    this.softWrap = true,
    this.overflow = TextOverflow.ellipsis,
    this.maxLines,
    this.textScaleFactor,
    this.textWidthBasis,
    this.isVerticalCentered = true,
  })  : assert(maxLines == null || maxLines >= 0),
        assert(textScaleFactor == null || textScaleFactor >= 0);

  @override
  Widget build(BuildContext context) {
    if (!isVerticalCentered) {
      return Text(
        text,
        key: key,
        style: style,
        textAlign: textAlign,
        softWrap: softWrap,
        overflow: overflow,
        textScaler: textScaleFactor != null ? TextScaler.linear(textScaleFactor!) : MediaQuery.textScalerOf(context),
        textWidthBasis: textWidthBasis,
        maxLines: maxLines,
      );
    }

    final height = style?.height ?? 1.0;
    final fontSize = style?.fontSize ?? 14.0;
    final bottomPadding = (height * fontSize - fontSize) / 2.0;
    final baseline = (height * fontSize) - height * fontSize / 4.0;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Baseline(
        baselineType: TextBaseline.alphabetic,
        baseline: baseline,
        child: Text(
          text,
          key: key,
          style: style,
          textAlign: textAlign,
          softWrap: softWrap,
          overflow: overflow,
          textScaler: textScaleFactor != null ? TextScaler.linear(textScaleFactor!) : MediaQuery.textScalerOf(context),
          textWidthBasis: textWidthBasis,
          maxLines: maxLines,
        ),
      ),
    );
  }
}

class CustomRichText extends StatelessWidget {
  final InlineSpan span;
  final TextAlign textAlign;
  final bool softWrap;
  final TextOverflow overflow;
  final int? maxLines;
  final double? textScaleFactor;
  final TextWidthBasis? textWidthBasis;

  const CustomRichText({
    super.key,
    required this.span,
    this.textAlign = TextAlign.start,
    this.softWrap = true,
    this.overflow = TextOverflow.ellipsis,
    this.maxLines,
    this.textScaleFactor,
    this.textWidthBasis,
  })  : assert(maxLines == null || maxLines >= 0),
        assert(textScaleFactor == null || textScaleFactor >= 0);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      span,
      key: key,
      textAlign: textAlign,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaleFactor != null ? TextScaler.linear(textScaleFactor!) : TextScaler.noScaling,
      textWidthBasis: textWidthBasis,
      maxLines: maxLines,
    );
  }
}