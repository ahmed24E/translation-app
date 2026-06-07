import 'package:dartz/dartz.dart';
import 'package:transelation_p/core/errors/exceptions.dart';
import 'package:transelation_p/core/errors/failures.dart';
import 'package:transelation_p/core/network/network_info.dart';
import 'package:transelation_p/feature/translator/data/datasources/translation_local_datasource.dart';
import 'package:transelation_p/feature/translator/data/datasources/translation_remote_datasource.dart';
import 'package:transelation_p/feature/translator/data/models/translation_hive_model.dart';
import 'package:transelation_p/feature/translator/domain/entities/translation_entity.dart';
import 'package:transelation_p/feature/translator/domain/entities/similar_word_entity.dart';
import 'package:transelation_p/feature/translator/domain/repositories/translation_repository.dart';

class TranslationRepositoryImpl implements TranslationRepository {
  final TranslationLocalDataSource localDataSource;
  final TranslationRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  TranslationRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });


  @override
  Future<Either<Failure, TranslationEntity>> translate({
    required String sourceText,
    required String sourceLang,
    required String targetLang,
  }) async {

    try {
      final cached = localDataSource.getCachedTranslation(
        sourceText,
        sourceLang,
        targetLang,
      );

      if (cached != null) {
        
        return Right(_mapToEntity(cached));
      }
    } on CacheException {
      
    }

   
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Left(
        NetworkFailure('No internet connection. Check your network.'),
      );
    }

    
    try {
      final remoteModel = await remoteDataSource.translate(
        sourceText: sourceText,
        sourceLang: sourceLang,
        targetLang: targetLang,
      );

      
      try {
        await localDataSource.saveTranslation(remoteModel);
      } on CacheException {
       
      }

     
      return Right(_mapToEntity(remoteModel));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  
  @override
  Future<Either<Failure, List<SimilarWordEntity>>> getSimilarWords({
    required String sourceWord,
    required String targetLang,
  }) async {
    try {
      final models = localDataSource.getSimilarWords(sourceWord, targetLang);

      final entities = models
          .map(
            (m) => SimilarWordEntity(
              sourceWord: m.sourceText,
              translatedWord: m.translatedText,
              sourceLang: m.sourceLang,
              targetLang: m.targetLang,
            ),
          )
          .toList();

      return Right(entities);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  
  @override
  Future<Either<Failure, List<TranslationEntity>>> getHistory() async {
    try {
      final models = localDataSource.getAllTranslations();

      final entities = models.map((m) => _mapToEntity(m)).toList();

      return Right(entities);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  
  @override
  Future<Either<Failure, void>> clearHistory() async {
    try {
      await localDataSource.clearAll();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

 
  TranslationEntity _mapToEntity(TranslationHiveModel model) {
    return TranslationEntity(
      sourceText: model.sourceText,
      translatedText: model.translatedText,
      sourceLang: model.sourceLang,
      targetLang: model.targetLang,
      timestampMs: model.timestampMs,
    );
  }
}
