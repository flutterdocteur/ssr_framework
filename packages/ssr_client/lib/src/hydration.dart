import 'dart:convert';
import 'dart:html';

/// Hydration service for SSR
class HydrationService {
  /// Hydrate initial data from server
  Map<String, dynamic>? hydrate() {
    try {
      final script = document.getElementById('initial-data');
      if (script == null) {
        print('[Hydration] No initial-data script found');
        return null;
      }

      final jsonStr = script.text;
      if (jsonStr == null || jsonStr.isEmpty) {
        print('[Hydration] initial-data script is empty');
        return null;
      }

      print('[Hydration] Hydrating from initial-data script');
      final data = jsonDecode(jsonStr);

      if (data is Map) {
        return Map<String, dynamic>.from(data);
      } else if (data is List) {
        return {'data': data.cast<Map<String, dynamic>>()};
      }

      return null;
    } catch (e) {
      print('[Hydration] Error hydrating data: $e');
      return null;
    }
  }
}
