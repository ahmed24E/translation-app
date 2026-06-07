import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transelation_p/feature/translator/domain/usecases/get_history_usecase.dart';
import 'package:transelation_p/feature/translator/domain/usecases/clear_history_usecase.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetHistoryUseCase getHistoryUseCase;
  final ClearHistoryUseCase clearHistoryUseCase;

  HistoryBloc({
    required this.getHistoryUseCase,
    required this.clearHistoryUseCase,
  }) : super(const HistoryState()) {
    on<LoadHistoryEvent>(_onLoadHistory);
    on<ClearHistoryEvent>(_onClearHistory);
    on<SearchHistoryEvent>(_onSearchHistory);
  }


  Future<void> _onLoadHistory(
    LoadHistoryEvent event,
    Emitter<HistoryState> emit,
  ) async {
    emit(state.copyWith(status: HistoryStatus.loading));

    final result = await getHistoryUseCase();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: HistoryStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (translations) {
        if (translations.isEmpty) {
          emit(state.copyWith(status: HistoryStatus.empty, translations: []));
        } else {
          emit(
            state.copyWith(
              status: HistoryStatus.loaded,
              translations: translations,
            ),
          );
        }
      },
    );
  }

  Future<void> _onClearHistory(
    ClearHistoryEvent event,
    Emitter<HistoryState> emit,
  ) async {
    final result = await clearHistoryUseCase();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: HistoryStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(
            status: HistoryStatus.empty,
            translations: [],
            filteredTranslations: [],
            searchQuery: '',
          ),
        );
      },
    );
  }

  void _onSearchHistory(SearchHistoryEvent event, Emitter<HistoryState> emit) {
    final query = event.query.toLowerCase().trim();

    if (query.isEmpty) {
      emit(state.copyWith(searchQuery: '', filteredTranslations: []));
      return;
    }

    final filtered = state.translations.where((t) {
      return t.sourceText.toLowerCase().contains(query) ||
          t.translatedText.toLowerCase().contains(query);
    }).toList();

    emit(state.copyWith(searchQuery: query, filteredTranslations: filtered));
  }
}
