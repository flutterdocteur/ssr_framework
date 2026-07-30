/// Data transfer utilities for hydration
class DataTransfer {
  /// Transfer data from server to client
  static String toScriptTag(Map<String, dynamic> data) {
    return '<script id="initial-data" type="application/json">${_serialize(data)}</script>';
  }

  static String _serialize(Map<String, dynamic> data) {
    // Simple JSON serialization
    return data.toString();
  }
}
