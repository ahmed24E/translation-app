import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'package:transelation_p/core/network/dio_client.dart';
import 'package:transelation_p/core/network/network_info.dart';

import 'package:transelation_p/feature/translator/data/models/translation_hive_model.dart';
import 'package:transelation_p/feature/translator/data/datasources/translation_local_datasource.dart';
import 'package:transelation_p/feature/translator/data/datasources/translation_remote_datasource.dart';
import 'package:transelation_p/feature/translator/data/repositories/translation_repository_impl.dart';

import 'package:transelation_p/feature/translator/domain/repositories/translation_repository.dart';
import 'package:transelation_p/feature/translator/domain/usecases/translate_text_usecase.dart';
import 'package:transelation_p/feature/translator/domain/usecases/get_similar_words_usecase.dart';
import 'package:transelation_p/feature/translator/domain/usecases/get_history_usecase.dart';
import 'package:transelation_p/feature/translator/domain/usecases/clear_history_usecase.dart';

import 'package:transelation_p/feature/translator/presentation/bloc/translator_bloc.dart';
import 'package:transelation_p/feature/history/presentation/bloc/history_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {

  final dioClient = DioClient();
  sl.registerLazySingleton<Dio>(() => dioClient.dio);

  
  sl.registerLazySingleton<InternetConnection>(() => InternetConnection());

  
  sl.registerLazySingleton<Box<TranslationHiveModel>>(
    () => Hive.box<TranslationHiveModel>('translations_hive'),
  );

  
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl<InternetConnection>()),
  );



  sl.registerLazySingleton<TranslationLocalDataSource>(
    () => TranslationLocalDataSourceImpl(sl<Box<TranslationHiveModel>>()),
  );

  sl.registerLazySingleton<TranslationRemoteDataSource>(
    () => TranslationRemoteDataSourceImpl(sl<Dio>()),
  );



  sl.registerLazySingleton<TranslationRepository>(
    () => TranslationRepositoryImpl(
      localDataSource: sl<TranslationLocalDataSource>(),
      remoteDataSource: sl<TranslationRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );



  sl.registerLazySingleton(
    () => TranslateTextUseCase(sl<TranslationRepository>()),
  );

  sl.registerLazySingleton(
    () => GetSimilarWordsUseCase(sl<TranslationRepository>()),
  );

  sl.registerLazySingleton(
    () => GetHistoryUseCase(sl<TranslationRepository>()),
  );

  sl.registerLazySingleton(
    () => ClearHistoryUseCase(sl<TranslationRepository>()),
  );

  

  sl.registerFactory(
    () => TranslatorBloc(
      translateTextUseCase: sl<TranslateTextUseCase>(),
      getSimilarWordsUseCase: sl<GetSimilarWordsUseCase>(),
    ),
  );

  sl.registerFactory(
    () => HistoryBloc(
      getHistoryUseCase: sl<GetHistoryUseCase>(),
      clearHistoryUseCase: sl<ClearHistoryUseCase>(),
    ),
  );
}
