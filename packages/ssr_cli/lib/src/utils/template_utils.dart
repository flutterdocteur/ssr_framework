class TemplateUtils {
  /// Convert a string to PascalCase
  static String toPascalCase(String s) {
    return s.split(RegExp(r'[-_\s]+')).map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join('');
  }

  /// Convert a string to camelCase
  static String toCamelCase(String s) {
    final pascal = toPascalCase(s);
    if (pascal.isEmpty) return pascal;
    return pascal[0].toLowerCase() + pascal.substring(1);
  }

  /// Convert a string to snake_case
  static String toSnakeCase(String s) {
    return s
        .replaceAllMapped(
          RegExp(r'([a-z])([A-Z])'),
          (match) => '${match.group(1)}_${match.group(2)}',
        )
        .replaceAll(RegExp(r'[-\s]+'), '_')
        .toLowerCase();
  }

  /// Convert a string to kebab-case
  static String toKebabCase(String s) {
    return toSnakeCase(s).replaceAll('_', '-');
  }

  /// Capitalize first letter
  static String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  /// Extract route path from file path
  /// e.g., "lib/pages/profile/detail.dart" -> "/profile/detail"
  static String fileToRoute(String filePath) {
    var route = filePath
        .replaceAll(RegExp(r'^lib/pages/'), '')
        .replaceAll(RegExp(r'\.dart$'), '')
        .replaceAll(RegExp(r'/index$'), '')
        .replaceAll(RegExp(r'\[(\w+)\]'), ':$1')
        .replaceAll('_', '-');

    if (route.isEmpty) return '/';
    return '/$route';
  }

  /// Generate a unique identifier
  static String generateId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = DateTime.now().microsecond;
    return '${timestamp}_$random';
  }

  /// Format a date for display
  static String formatDate(DateTime date) {
    return '${date.year}-${_pad(date.month)}-${_pad(date.day)}';
  }

  /// Format a datetime for display
  static String formatDateTime(DateTime date) {
    return '${formatDate(date)} ${_pad(date.hour)}:${_pad(date.minute)}';
  }

  static String _pad(int n) => n.toString().padLeft(2, '0');
}
