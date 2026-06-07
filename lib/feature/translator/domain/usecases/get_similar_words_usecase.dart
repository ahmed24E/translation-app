import 'package:dartz/dartz.dart';
import 'package:transelation_p/core/errors/failures.dart';
import 'package:transelation_p/feature/translator/domain/entities/similar_word_entity.dart';
import 'package:transelation_p/feature/translator/domain/repositories/translation_repository.dart';

class GetSimilarWordsUseCase {
  final TranslationRepository repository;

  GetSimilarWordsUseCase(this.repository);

  Future<Either<Failure, List<SimilarWordEntity>>> call({
    required String sourceWord,
    required String targetLang,
  }) {
    return repository.getSimilarWords(
      sourceWord: sourceWord,
      targetLang: targetLang,
    );
  }
}
