import 'package:transelation_p/feature/translator/domain/entities/similar_word_entity.dart';
import 'package:transelation_p/feature/translator/domain/entities/translation_entity.dart';

enum TranslatorStatus { initial, loading, success, error }

class TranslatorState {
  final TranslatorStatus status;
  final String sourceLang;
  final String targetLang;
  final String sourceText;
  final TranslationEntity? translation;
  final List<SimilarWordEntity> similarWords;
  final String errorMessage;
  final bool isCached; 

  const TranslatorState({
    this.status = TranslatorStatus.initial,
    this.sourceLang = 'en',
    this.targetLang = 'it',
    this.sourceText = '',
    this.translation,
    this.similarWords = const [],
    this.errorMessage = '',
    this.isCached = false,
  });


  TranslatorState copyWith({
    TranslatorStatus? status,
    String? sourceLang,
    String? targetLang,
    String? sourceText,
    TranslationEntity? translation,
    List<SimilarWordEntity>? similarWords,
    String? errorMessage,
    bool? isCached,
  }) {
    return TranslatorState(
      status: status ?? this.status,
      sourceLang: sourceLang ?? this.sourceLang,
      targetLang: targetLang ?? this.targetLang,
      sourceText: sourceText ?? this.sourceText,
      translation: translation ?? this.translation,
      similarWords: similarWords ?? this.similarWords,
      errorMessage: errorMessage ?? this.errorMessage,
      isCached: isCached ?? this.isCached,
    );
  }
}
