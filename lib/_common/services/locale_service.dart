part of '../common.dart';

class LocaleProvider with ChangeNotifier {
  LanguageType _language = LanguageType.ru;
  LanguageType get language => _language;

  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    // Locale.fromSubtags(languageCode: 'uz', scriptCode: 'Cyrl'),
    // Locale.fromSubtags(languageCode: 'uz', scriptCode: 'Latn'),
  ];

  Locale getLocale({LanguageType? language}) => (language ?? locator<LocaleProvider>().language).toLocale();

  Future<void> init() async {
    LoggerService.logTrace('LocaleProvider -> init()');

    /// Read saved locale
    final locale = await locator<AppPreferencesStorage>().readLocale();
    if (supportedLocales.contains(locale)) {
      _language = LanguageType.fromLocale(locale!);
      return;
    }

    /// Read device locale
    final deviceLocale = Locale.fromSubtags(languageCode: Platform.localeName);
    if (supportedLocales.contains(deviceLocale)) {
      _language = LanguageType.fromLocale(deviceLocale);
      return;
    }

    /// Default locale
    _language = LanguageType.ru;
  }

  Future<void> updateLocale({required BuildContext context, required LanguageType language}) async {
    LoggerService.logTrace('LocaleProvider -> updateLocale()');
    if (LanguageType.fromLocale(context.locale) == language) {
      return;
    }

    _language = language;
    await context.setLocale(language.toLocale());
    await locator<AppPreferencesStorage>().writeLocale(language.toLocale());
    notifyListeners();
  }
}

/// When we are using many json files
class MergedAssetLoader extends localization.AssetLoader {
  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    final languageSpecific = '${locale.languageCode}${locale.scriptCode != null ? '-${locale.scriptCode}' : ''}';
    final commonPath = 'packages/.../assets/translations/_common/$languageSpecific.json';
    final appPath = 'packages/.../assets/translations/.../$languageSpecific.json';

    final commonJson = await rootBundle.loadString(commonPath);
    final appJson = await rootBundle.loadString(appPath);

    final commonMap = json.decode(commonJson);
    final appMap = json.decode(appJson);

    return {
      ...commonMap,
      ...appMap,
    };
  }
}