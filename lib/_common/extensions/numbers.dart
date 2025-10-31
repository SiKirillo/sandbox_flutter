part of '../common.dart';

extension NumbersExtension on num {
  String toFormattedWithDots({LanguageType? language}) {
    return localization.NumberFormat('#,###', locator<LocaleProvider>().getLocale(language: language).toString()).format(truncate()).replaceAll(' ', '.');
  }
}