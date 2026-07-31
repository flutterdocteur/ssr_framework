import 'dart:convert';

/// Hydration engine for transferring server state to client
class HydrationEngine {
  /// Serialize data for hydration
  String serialize(Map<String, dynamic> data) {
    return jsonEncode(data);
  }

  /// Deserialize hydrated data
  Map<String, dynamic> deserialize(String json) {
    return jsonDecode(json) as Map<String, dynamic>;
  }

  /// Generate hydration script tag
  String generateScriptTag(Map<String, dynamic> data) {
    final json = serialize(data);
    return '<script id="initial-data" type="application/json">$json</script>';
  }
}
