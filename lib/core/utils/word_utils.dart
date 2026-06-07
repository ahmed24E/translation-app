class WordUtils {
  WordUtils._();

  static String findRoot(String word) {
    final w = word.toLowerCase().trim();
    if (w.length <= 3) return w;

    if (w.endsWith('ing') && w.length > 4) {
      final stem = w.substring(0, w.length - 3);

      if (stem.length >= 2 && stem[stem.length - 1] == stem[stem.length - 2]) {
        return stem.substring(0, stem.length - 1);
      }
      return stem;
    }
    if (w.endsWith('tion') && w.length > 5) {
      return w.substring(0, w.length - 4);
    }
    if (w.endsWith('er') && w.length > 3) {
      return w.substring(0, w.length - 2);
    }
    if (w.endsWith('ed') && w.length > 3) {
      final stem = w.substring(0, w.length - 2);

      if (stem.length >= 2 && stem[stem.length - 1] == stem[stem.length - 2]) {
        return stem.substring(0, stem.length - 1);
      }
      return stem;
    }
    if (w.endsWith('es') && w.length > 3) {
      return w.substring(0, w.length - 2);
    }
    if (w.endsWith('s') && w.length > 2) {
      return w.substring(0, w.length - 1);
    }

    return w;
  }

  static String classifyWord(String word, String root) {
    final w = word.toLowerCase().trim();
    if (w == root) return 'root';
    if (w.endsWith('ing')) return 'gerund';
    if (w.endsWith('er') || w.endsWith('or')) return 'agent';
    if (w.endsWith('ed')) return 'past';
    if (w.endsWith('s')) return 'plural';
    return 'other';
  }

  static bool sharesRoot(String wordA, String wordB) {
    if (wordA.isEmpty || wordB.isEmpty) return false;
    final rootA = findRoot(wordA.toLowerCase().trim());
    final rootB = findRoot(wordB.toLowerCase().trim());
    return rootA == rootB;
  }
}
