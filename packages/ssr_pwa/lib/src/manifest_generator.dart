import 'dart:convert';

/// Manifest generator for PWA
class ManifestGenerator {
  /// Generate manifest.json
  static String generate({
    required String name,
    required String shortName,
    required String description,
    required String startUrl,
    required String themeColor,
    required String backgroundColor,
    List<Map<String, dynamic>>? icons,
  }) {
    final manifest = {
      'name': name,
      'short_name': shortName,
      'description': description,
      'start_url': startUrl,
      'display': 'standalone',
      'theme_color': themeColor,
      'background_color': backgroundColor,
      if (icons != null) 'icons': icons,
    };

    return jsonEncode(manifest);
  }
}
