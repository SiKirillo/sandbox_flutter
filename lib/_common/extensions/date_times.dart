part of '../common.dart';

extension DateTimeExtension on DateTime? {
  String? toFormattedDate() {
    if (this == null) return null;
    final year = this!.year.toString().padLeft(4, '0');
    final month = this!.month.toString().padLeft(2, '0');
    final day = this!.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}

extension DurationExtension on Duration? {
  String toMinutesAndSeconds({bool isShort = false}) {
    final time = toString().split('.').first.padLeft(8, '0');
    final minutes = isShort ? time.split(':')[1][1] : time.split(':')[1];
    final seconds = time.split(':')[2];
    return '$minutes:$seconds';
  }
}
