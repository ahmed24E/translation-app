import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transelation_p/feature/translator/domain/usecases/translate_text_usecase.dart';
import 'package:transelation_p/feature/translator/domain/usecases/get_similar_words_usecase.dart';
import 'translator_event.dart';
import 'translator_state.dart';

class TranslatorBloc extends Bloc<TranslatorEvent, TranslatorState> {
  final TranslateTextUseCase translateTextUseCase;
  final GetSimilarWordsUseCase getSimilarWordsUseCase;

  TranslatorBloc({
    required this.translateTextUseCase,
    required this.getSimilarWordsUseCase,
  }) : super(const TranslatorState()) {
    on<TranslateEvent>(_onTranslate);
    on<ChangeSourceLangEvent>(_onChangeSourceLang);
    on<ChangeTargetLangEvent>(_onChangeTargetLang);
    on<SwapLanguagesEvent>(_onSwapLanguages);
    on<LoadSimilarWordsEvent>(_onLoadSimilarWords);
    on<ClearTranslationEvent>(_onClear);
  }


  Future<void> _onTranslate(
    TranslateEvent event,
    Emitter<TranslatorState> emit,
  ) async {
  
    if (event.sourceText.trim().isEmpty) return;

 
    if (event.sourceLang == event.targetLang) {
      emit(
        state.copyWith(
          status: TranslatorStatus.error,
          errorMessage: 'Source and target languages cannot be the same.',
        ),
      );
      return;
    }

   
    emit(
      state.copyWith(
        status: TranslatorStatus.loading,
        sourceText: event.sourceText,
        errorMessage: '',
      ),
    );

    
    final result = await translateTextUseCase(
      sourceText: event.sourceText,
      sourceLang: event.sourceLang,
      targetLang: event.targetLang,
    );

    result.fold(
      
      (failure) {
        emit(
          state.copyWith(
            status: TranslatorStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
    
      (translation) {
        emit(
          state.copyWith(
            status: TranslatorStatus.success,
            translation: translation,
            errorMessage: '',
          ),
        );

    
        if (translation.isSingleWord) {
          add(
            LoadSimilarWordsEvent(
              word: event.sourceText.trim(),
              targetLang: event.targetLang,
            ),
          );
        }
      },
    );
  }


  void _onChangeSourceLang(
    ChangeSourceLangEvent event,
    Emitter<TranslatorState> emit,
  ) {
    emit(state.copyWith(sourceLang: event.langCode));
  }


  void _onChangeTargetLang(
    ChangeTargetLangEvent event,
    Emitter<TranslatorState> emit,
  ) {
    emit(state.copyWith(targetLang: event.langCode));
  }


  void _onSwapLanguages(
    SwapLanguagesEvent event,
    Emitter<TranslatorState> emit,
  ) {
    emit(
      state.copyWith(
        sourceLang: state.targetLang,
        targetLang: state.sourceLang,
      ),
    );
  }


  Future<void> _onLoadSimilarWords(
    LoadSimilarWordsEvent event,
    Emitter<TranslatorState> emit,
  ) async {
    final result = await getSimilarWordsUseCase(
      sourceWord: event.word,
      targetLang: event.targetLang,
    );

    result.fold(

      (_) => emit(state.copyWith(similarWords: [])),
   
      (words) => emit(state.copyWith(similarWords: words)),
    );
  }


  void _onClear(ClearTranslationEvent event, Emitter<TranslatorState> emit) {
    emit(const TranslatorState());
  }
}
