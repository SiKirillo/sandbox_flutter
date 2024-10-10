part of '../common.dart';

extension PhomeNumbersExtension on String {
  static String toJsonPhoneFormat(String fullNumber, String childNumber) {
    assert(childNumber.length == 12);
    if (fullNumber.split('_').length > 1) {
      return '${fullNumber.split('_').first}_${childNumber.substring(3)}';
    } else {
      return childNumber;
    }
  }

  String toDigitsOnly({int? length}) {
    final formattedNumber = replaceAll(RegExp(r'[\D+]'), '');
    if (length != null && formattedNumber.length > length) {
      formattedNumber.substring(formattedNumber.length - length);
    }

    return formattedNumber;
  }

  String toParsedPhoneFormat() {
    assert(length == 19 || length == 12 || length == 9);
    if (length == 19) {
      final childPhone = split('_').last;
      return '+375 (${childPhone.substring(0, 2)}) ${childPhone.substring(2, 5)}-${childPhone.substring(5, 7)}-${childPhone.substring(7, 9)}';
    } else if (length == 12) {
      return '+375 (${substring(3, 5)}) ${substring(5, 8)}-${substring(8, 10)}-${substring(10, 12)}';
    } else {
      return '+375 (${substring(0, 2)}) ${substring(2, 5)}-${substring(5, 7)}-${substring(7, 9)}';
    }
  }

  String toParsedPhoneFormatFromContacts() {
    final formattedNumber = toDigitsOnly();

    if (formattedNumber.length == 11 && formattedNumber[0] == '8') {
      return '+ 375 (${formattedNumber.substring(2, 4)}) ${formattedNumber.substring(4, 7)}-${formattedNumber.substring(7, 9)}-${formattedNumber.substring(9, 11)}';
    }

    if (formattedNumber.length == 12 && formattedNumber.substring(0, 3) == '375') {
      return '+ 375 (${formattedNumber.substring(3, 5)}) ${formattedNumber.substring(5, 8)}-${formattedNumber.substring(8, 10)}-${formattedNumber.substring(10, 12)}';
    }

    if (formattedNumber.length < 2) {
      return '+ 375 (${formattedNumber.substring(0)}';
    }

    String parsedNumber = '+ 375';
    if (formattedNumber.length >= 2) {
      parsedNumber += ' (${formattedNumber.substring(0, 2)})';
    }

    if (formattedNumber.length >= 3) {
      parsedNumber += ' ${formattedNumber.substring(2, formattedNumber.length >= 5 ? 5 : formattedNumber.length)}';
    }

    if (formattedNumber.length >= 6) {
      parsedNumber += '-${formattedNumber.substring(5, formattedNumber.length >= 7 ? 7 : formattedNumber.length)}';
    }

    if (formattedNumber.length >= 8) {
      parsedNumber += '-${formattedNumber.substring(7, formattedNumber.length >= 9 ? 9 : formattedNumber.length)}';
    }

    return parsedNumber;
  }
}