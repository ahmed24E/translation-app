class AppConstants {
  AppConstants._();


  static const String baseUrl = 'https://api.mymemory.translated.net';
  static const String translateEndpoint = '/get';

  static const String translationsBoxName = 'translations_hive';
  static const int translationHiveTypeId = 0;


  static const Map<String, String> supportedLanguages = {
    'English': 'en',
    'Italian': 'it',
    'French': 'fr',
    'Spanish': 'es',
    'German': 'de',
    'Japanese': 'ja',
    'Arabic': 'ar',
    'Portuguese': 'pt',
  };

  
  static String langName(String code) => supportedLanguages.entries
      .firstWhere(
        (e) => e.value == code,
        orElse: () => const MapEntry('Unknown', ''),
      )
      .key;

  static String langCode(String name) => supportedLanguages[name] ?? 'en';
}
