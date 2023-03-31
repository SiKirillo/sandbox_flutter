import 'package:flutter/material.dart';

/// It works as usual [Text] widget, but it's more controllable
/// (you don't have to search all Text-s if you want to change something)
class SandboxText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final bool softWrap;
  final TextOverflow overflow;
  final int? maxLines;
  final double? textScaleFactor;

  /// Flutter engine does not support text vertical alignment.
  /// This is custom solution for this
  final bool isVerticalCentered;

  const SandboxText({
    Key? key,
    required this.text,
    this.style,
    this.textAlign = TextAlign.start,
    this.softWrap = true,
    this.overflow = TextOverflow.ellipsis,
    this.maxLines,
    this.textScaleFactor,
    this.isVerticalCentered = true,
  })  : assert(maxLines == null || maxLines >= 0),
        assert(textScaleFactor == null || textScaleFactor >= 0),
        super(key: key);

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
        textScaleFactor: textScaleFactor ?? MediaQuery.of(context).textScaleFactor,
        maxLines: maxLines,
      );
    }

    final height = style?.height ?? Theme.of(context).textTheme.bodyLarge?.height ?? 1.0;
    final textSize = style?.fontSize ?? Theme.of(context).textTheme.bodyLarge?.fontSize ?? 14.0;
    final bottomPadding = (height * textSize - textSize) / 2.0;
    final baseline = height * textSize - height * textSize / 4.0;

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
          textScaleFactor: textScaleFactor ?? MediaQuery.of(context).textScaleFactor,
          maxLines: maxLines,
        ),
      ),
    );
  }
}

class SandboxRichText extends StatelessWidget {
  final InlineSpan span;
  final TextAlign textAlign;
  final bool softWrap;
  final TextOverflow overflow;
  final int? maxLines;
  final double? textScaleFactor;

  const SandboxRichText({
    Key? key,
    required this.span,
    this.textAlign = TextAlign.start,
    this.softWrap = true,
    this.overflow = TextOverflow.ellipsis,
    this.maxLines,
    this.textScaleFactor,
  })  : assert(maxLines == null || maxLines >= 0),
        assert(textScaleFactor == null || textScaleFactor >= 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: span,
      key: key,
      textAlign: textAlign,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor ?? MediaQuery.of(context).textScaleFactor,
      maxLines: maxLines,
    );
  }
}