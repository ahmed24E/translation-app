abstract class TranslatorEvent {}


class TranslateEvent extends TranslatorEvent {
  final String sourceText;
  final String sourceLang;
  final String targetLang;

  TranslateEvent({
    required this.sourceText,
    required this.sourceLang,
    required this.targetLang,
  });
}


class ChangeSourceLangEvent extends TranslatorEvent {
  final String langCode;

  ChangeSourceLangEvent(this.langCode);
}


class ChangeTargetLangEvent extends TranslatorEvent {
  final String langCode;

  ChangeTargetLangEvent(this.langCode);
}


class SwapLanguagesEvent extends TranslatorEvent {}


class LoadSimilarWordsEvent extends TranslatorEvent {
  final String word;
  final String targetLang;

  LoadSimilarWordsEvent({required this.word, required this.targetLang});
}


class ClearTranslationEvent extends TranslatorEvent {}
