/// Meta tags generator
class MetaTags {
  /// Generate meta tags HTML
  static String generate({
    required String title,
    String? description,
    String? canonical,
    Map<String, String>? openGraph,
    Map<String, String>? twitter,
  }) {
    final buffer = StringBuffer();

    buffer.writeln('<title>$title</title>');
    
    if (description != null) {
      buffer.writeln('<meta name="description" content="$description">');
    }

    if (canonical != null) {
      buffer.writeln('<link rel="canonical" href="$canonical">');
    }

    if (openGraph != null) {
      openGraph.forEach((key, value) {
        buffer.writeln('<meta property="og:$key" content="$value">');
      });
    }

    if (twitter != null) {
      twitter.forEach((key, value) {
        buffer.writeln('<meta name="twitter:$key" content="$value">');
      });
    }

    return buffer.toString();
  }
}
