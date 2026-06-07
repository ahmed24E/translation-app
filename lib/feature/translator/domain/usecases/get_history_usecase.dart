import 'package:dartz/dartz.dart';
import 'package:transelation_p/core/errors/failures.dart';
import 'package:transelation_p/feature/translator/domain/entities/translation_entity.dart';
import 'package:transelation_p/feature/translator/domain/repositories/translation_repository.dart';

class GetHistoryUseCase {
  final TranslationRepository repository;

  GetHistoryUseCase(this.repository);

  Future<Either<Failure, List<TranslationEntity>>> call() {
    return repository.getHistory();
  }
}
