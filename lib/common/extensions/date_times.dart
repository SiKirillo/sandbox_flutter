part of '../common.dart';

extension DateTimeExtension on DateTime? {
  String toTimeOnly() {
    if (this == null) return '--:--';
    return localization.DateFormat('HH:mm').format(this!);
  }

  String? toMonthAndDayOnly(BuildContext context) {
    if (this == null) return null;

    final locale = context.locale.languageCode;
    final formattedDay = localization.DateFormat('d', locale).format(this!);
    final formattedMonth = localization.DateFormat('MMMM', locale).format(this!);

    return '$formattedMonth $formattedDay';
  }

  String? toCustomFormat(BuildContext context) {
    if (this == null) return null;

    final formattedDate = DateTime(this!.year, this!.month, this!.day, this!.hour, this!.minute, this!.second);
    final formattedCurrentDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, DateTime.now().minute, DateTime.now().second);
    final difference = formattedCurrentDate.difference(formattedDate);
    final locale = context.locale.languageCode;

    final formattedTime = localization.DateFormat('HH:mm', locale).format(formattedDate);
    final formattedDay = localization.DateFormat('d', locale).format(formattedDate);
    final formattedMonth = localization.DateFormat('MM', locale).format(formattedDate);
    final formattedWeekday = localization.DateFormat('EEE', locale).format(formattedDate);
    final formattedYear = localization.DateFormat('yy', locale).format(formattedDate);
    final isYearShowing = formattedCurrentDate.year > formattedDate.year;

    if (difference.inDays < 1) {
      return formattedTime;
    }

    final weekStartDay = formattedCurrentDate.subtract(Duration(days: formattedCurrentDate.weekday - 1));
    final weekStartDate = DateTime(weekStartDay.year, weekStartDay.month, weekStartDay.day);
    if (formattedDate.isAfter(weekStartDate)) {
      return formattedWeekday;
    }

    return '$formattedDay.$formattedMonth${isYearShowing ? '.$formattedYear' : ''}';
  }
}