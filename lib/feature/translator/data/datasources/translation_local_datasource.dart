import 'package:hive/hive.dart';
import 'package:transelation_p/core/errors/exceptions.dart';
import 'package:transelation_p/core/utils/word_utils.dart';
import 'package:transelation_p/feature/translator/data/models/translation_hive_model.dart';

abstract class TranslationLocalDataSource {
  TranslationHiveModel? getCachedTranslation(
    String sourceText,
    String sourceLang,
    String targetLang,
  );

  Future<void> saveTranslation(TranslationHiveModel model);

  List<TranslationHiveModel> getSimilarWords(
    String sourceWord,
    String targetLang,
  );

  List<TranslationHiveModel> getAllTranslations();

  Future<void> clearAll();
}


class TranslationLocalDataSourceImpl implements TranslationLocalDataSource {
  final Box<TranslationHiveModel> box;

  TranslationLocalDataSourceImpl(this.box);

 
  @override
  TranslationHiveModel? getCachedTranslation(
    String sourceText,
    String sourceLang,
    String targetLang,
  ) {
    try {
      final key = TranslationHiveModel.cacheKey(
        sourceText,
        sourceLang,
        targetLang,
      );
      return box.get(key);
    } catch (e) {
      throw CacheException('Failed to read cache: $e');
    }
  }


  @override
  Future<void> saveTranslation(TranslationHiveModel model) async {
    try {
      
      if (!box.containsKey(model.ownKey)) {
        await box.put(model.ownKey, model);
      }
    } catch (e) {
      throw CacheException('Failed to save translation: $e');
    }
  }

 
  @override
  List<TranslationHiveModel> getSimilarWords(
    String sourceWord,
    String targetLang,
  ) {
    try {
      return box.values
          .where(
            (m) =>
                m.targetLang == targetLang &&
                
                m.sourceText.trim().split(' ').length == 1 &&
                WordUtils.sharesRoot(sourceWord, m.sourceText),
          )
          .toList()
        
        ..sort((a, b) => a.sourceText.length.compareTo(b.sourceText.length));
    } catch (e) {
      throw CacheException('Failed to get similar words: $e');
    }
  }


  @override
  List<TranslationHiveModel> getAllTranslations() {
    try {
      return box.values.toList()
        ..sort((a, b) => b.timestampMs.compareTo(a.timestampMs));
    } catch (e) {
      throw CacheException('Failed to load history: $e');
    }
  }


  @override
  Future<void> clearAll() async {
    try {
      await box.clear();
    } catch (e) {
      throw CacheException('Failed to clear cache: $e');
    }
  }
}
