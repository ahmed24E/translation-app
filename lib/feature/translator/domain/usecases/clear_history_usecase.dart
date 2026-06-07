import 'package:dartz/dartz.dart';
import 'package:transelation_p/core/errors/failures.dart';
import 'package:transelation_p/feature/translator/domain/repositories/translation_repository.dart';

class ClearHistoryUseCase {
  final TranslationRepository repository;

  ClearHistoryUseCase(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.clearHistory();
  }
}
