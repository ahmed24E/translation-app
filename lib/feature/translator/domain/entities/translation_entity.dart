class TranslationEntity {
  final String sourceText;
  final String translatedText;
  final String sourceLang;
  final String targetLang;
  final int timestampMs;

  const TranslationEntity({
    required this.sourceText,
    required this.translatedText,
    required this.sourceLang,
    required this.targetLang,
    required this.timestampMs,
  });


  String get formattedDate {
    final date = DateTime.fromMillisecondsSinceEpoch(timestampMs);
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }


  bool get isSingleWord => sourceText.trim().split(' ').length == 1;
}
