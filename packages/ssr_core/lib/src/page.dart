/// Represents a page in the SSR application
abstract class SsrPage {
  /// Route path for this page
  String get path;

  /// Page title
  String get title;

  /// Page description for SEO
  String? get description;

  /// Render the page with given data
  Future<String> render(Map<String, dynamic> data);

  /// Get initial data for hydration
  Future<Map<String, dynamic>> getInitialData();
}

/// Base implementation of SsrPage
abstract class SsrPageBase implements SsrPage {
  @override
  final String path;

  @override
  final String title;

  @override
  final String? description;

  SsrPageBase({
    required this.path,
    required this.title,
    this.description,
  });

  @override
  Future<Map<String, dynamic>> getInitialData() async {
    return {};
  }
}

/// Dynamic page with route parameters
abstract class SsrDynamicPage extends SsrPageBase {
  /// Route pattern (e.g., '/profile/:id')
  final String pattern;

  SsrDynamicPage({
    required super.path,
    required super.title,
    super.description,
    required this.pattern,
  });

  /// Extract parameters from path
  Map<String, String> extractParams(String actualPath);
}
