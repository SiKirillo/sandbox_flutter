part of '../common.dart';

extension PhomeNumbersExtension on String {
  String toDigits({int? length}) {
    final formattedNumber = replaceAll(RegExp(r'[\D+]'), '');
    if (length != null && formattedNumber.length > length) {
      formattedNumber.substring(formattedNumber.length - length);
    }

    return formattedNumber;
  }

  String toFormattedPhoneNumber() {
    final regExp = RegExp(r'^\+(\d{3})(\d{2})(\d{3})(\d{2})(\d{2})$');
    return replaceAllMapped(regExp, (match) {
      return '+${match[1]} ${match[2]} ${match[3]}-${match[4]}-${match[5]}';
    });
  }
}