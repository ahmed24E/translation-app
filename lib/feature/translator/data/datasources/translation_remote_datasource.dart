import 'package:dio/dio.dart';
import 'package:transelation_p/core/constants/app_constants.dart';
import 'package:transelation_p/core/errors/exceptions.dart';
import 'package:transelation_p/feature/translator/data/models/translation_hive_model.dart';


abstract class TranslationRemoteDataSource {
  Future<TranslationHiveModel> translate({
    required String sourceText,
    required String sourceLang,
    required String targetLang,
  });
}


class TranslationRemoteDataSourceImpl implements TranslationRemoteDataSource {
  final Dio dio;

  TranslationRemoteDataSourceImpl(this.dio);

  @override
  Future<TranslationHiveModel> translate({
    required String sourceText,
    required String sourceLang,
    required String targetLang,
  }) async {
    try {
    
      final response = await dio.get(
        AppConstants.translateEndpoint,
        queryParameters: {
          'q': sourceText,
          'langpair': '$sourceLang|$targetLang',
        },
      );

 
      if (response.statusCode != 200) {
        throw ServerException('API returned status ${response.statusCode}');
      }

      final data = response.data;

     
      final apiStatus = data['responseStatus'];
      if (apiStatus != 200) {
        throw ServerException(_mapApiError(apiStatus));
      }

   
      if (data['quotaFinished'] == true) {
        throw ServerException('API quota exceeded. Try again later.');
      }

     
      final responseData = data['responseData'];
      if (responseData == null || responseData['translatedText'] == null) {
        throw ServerException('Invalid API response: missing translatedText');
      }

      final translatedText = responseData['translatedText'] as String;

      if (translatedText.isEmpty) {
        throw ServerException('API returned empty translation');
      }

  
      return TranslationHiveModel(
        sourceText: sourceText,
        translatedText: translatedText,
        sourceLang: sourceLang,
        targetLang: targetLang,
        timestampMs: DateTime.now().millisecondsSinceEpoch,
      );
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }


  ServerException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ServerException('Connection timeout. Check your internet.');
      case DioExceptionType.sendTimeout:
        return ServerException('Send timeout. Server is too slow.');
      case DioExceptionType.receiveTimeout:
        return ServerException('Receive timeout. Server took too long.');
      case DioExceptionType.connectionError:
        return ServerException('No internet connection.');
      case DioExceptionType.badResponse:
        return ServerException(
          'Server error: ${e.response?.statusMessage ?? 'Unknown'}',
        );
      case DioExceptionType.cancel:
        return ServerException('Request was cancelled.');
      default:
        return ServerException('Network error: ${e.message}');
    }
  }


  String _mapApiError(int? status) {
    switch (status) {
      case 403:
        return 'Access denied. Invalid language pair.';
      case 429:
        return 'Too many requests. Please wait.';
      case 500:
        return 'Translation service is down.';
      default:
        return 'Translation failed (API status: $status)';
    }
  }
}
