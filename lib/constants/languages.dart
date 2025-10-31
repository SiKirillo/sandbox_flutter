part of '../_common/common.dart';

enum LanguageType {
  en,
  ru;

  static LanguageType fromDto(String code) {
    return switch (code) {
      'en' => LanguageType.en,
      'ru' => LanguageType.ru,
      _ => throw Exception('Unknown type code: $code'),
    };
  }

  static LanguageType fromLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'en': {
        return LanguageType.ru;
      }

      case 'ru': {
        return LanguageType.ru;
      }

      /// Example with different language codes
      // case 'uz': {
      //   if (locale.scriptCode == 'Cyrl') {
      //     return LanguageType.uzCyrl;
      //   }
      //
      //   if (locale.scriptCode == 'Latn') {
      //     return LanguageType.uzLatn;
      //   }
      //
      //   return LanguageType.uzLatn;
      // }

      default:
        return LanguageType.en;
    }
  }

  Locale toLocale() {
    return switch (this) {
      LanguageType.en => Locale.fromSubtags(languageCode: 'en'),
      LanguageType.ru => Locale.fromSubtags(languageCode: 'ru'),
      // LanguageType.uzCyrl => Locale.fromSubtags(languageCode: 'uz', scriptCode: 'Cyrl'),
      // LanguageType.uzLatn => Locale.fromSubtags(languageCode: 'uz', scriptCode: 'Latn'),
    };
  }

  String toJson() {
    return switch (this) {
      LanguageType.en => 'en',
      LanguageType.ru => 'ru',
      // LanguageType.uzCyrl => 'uzCyrl',
      // LanguageType.uzLatn => 'uzLatn',
    };
  }
}
