import 'package:dartz/dartz.dart';
import 'package:transelation_p/core/errors/failures.dart';
import 'package:transelation_p/feature/translator/domain/entities/translation_entity.dart';
import 'package:transelation_p/feature/translator/domain/entities/similar_word_entity.dart';

abstract class TranslationRepository {
  
  Future<Either<Failure, TranslationEntity>> translate({
    required String sourceText,
    required String sourceLang,
    required String targetLang,
  });

  
  Future<Either<Failure, List<SimilarWordEntity>>> getSimilarWords({
    required String sourceWord,
    required String targetLang,
  });


  Future<Either<Failure, List<TranslationEntity>>> getHistory();


  Future<Either<Failure, void>> clearHistory();
}
