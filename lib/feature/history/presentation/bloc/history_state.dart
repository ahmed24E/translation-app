import 'package:transelation_p/feature/translator/domain/entities/translation_entity.dart';

enum HistoryStatus { initial, loading, loaded, empty, error }

class HistoryState {
  final HistoryStatus status;
  final List<TranslationEntity> translations;
  final List<TranslationEntity> filteredTranslations;
  final String searchQuery;
  final String errorMessage;

  const HistoryState({
    this.status = HistoryStatus.initial,
    this.translations = const [],
    this.filteredTranslations = const [],
    this.searchQuery = '',
    this.errorMessage = '',
  });

  HistoryState copyWith({
    HistoryStatus? status,
    List<TranslationEntity>? translations,
    List<TranslationEntity>? filteredTranslations,
    String? searchQuery,
    String? errorMessage,
  }) {
    return HistoryState(
      status: status ?? this.status,
      translations: translations ?? this.translations,
      filteredTranslations: filteredTranslations ?? this.filteredTranslations,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  
  List<TranslationEntity> get displayList =>
      searchQuery.isEmpty ? translations : filteredTranslations;
}
