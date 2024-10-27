extension MyExtension on String {
  String capitalize() {
    if (isEmpty) {
      return this;
    }
    final words = trim().split(' ');
    final capitalizedWords = words.map((word) {
      if (word.isEmpty) {
        return word;
      }
      final firstChar = word[0].toUpperCase();
      final restChars = word.substring(1).toLowerCase();
      return '$firstChar$restChars';
    });
    return capitalizedWords.join(' ');
  }

  String capitalizeSingle() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
