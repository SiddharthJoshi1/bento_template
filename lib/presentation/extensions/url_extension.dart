extension UrlExtension on String {
  String getBasePath() {
    // 1. The Regex
    final regExp = RegExp(r'^(?:https?:\/\/)?(?:www\.)?([^\/\?]+)');

    // 2. Find the match
    final match = regExp.firstMatch(this);

    // 3. Return the captured group (index 1), or the original URL if no match
    return match?.group(1) ?? this;
  }
}
