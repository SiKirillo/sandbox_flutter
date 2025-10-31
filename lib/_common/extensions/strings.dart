part of '../common.dart';

extension StringExtension on String {
  String toCamelCase() {
    if (isEmpty || this == '') return '';
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  Size calculateSize({
    TextStyle? style,
    int maxLines = 1,
    double maxWidth = double.maxFinite,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: this,
        style: style,
      ),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);
   return painter.size;
  }
}