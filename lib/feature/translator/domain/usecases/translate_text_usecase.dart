import 'package:dartz/dartz.dart';
import 'package:transelation_p/core/errors/failures.dart';
import 'package:transelation_p/feature/translator/domain/entities/translation_entity.dart';
import 'package:transelation_p/feature/translator/domain/repositories/translation_repository.dart';

class TranslateTextUseCase {
  final TranslationRepository repository;

  TranslateTextUseCase(this.repository);

  Future<Either<Failure, TranslationEntity>> call({
    required String sourceText,
    required String sourceLang,
    required String targetLang,
  }) {
    return repository.translate(
      sourceText: sourceText,
      sourceLang: sourceLang,
      targetLang: targetLang,
    );
  }
}
