class SimilarWordEntity {
  final String sourceWord;
  final String translatedWord;
  final String sourceLang;
  final String targetLang;

  const SimilarWordEntity({
    required this.sourceWord,
    required this.translatedWord,
    required this.sourceLang,
    required this.targetLang,
  });
}
