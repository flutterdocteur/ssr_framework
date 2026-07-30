/// Router interface for SSR applications
abstract class SsrRouter {
  /// Current route path
  String get currentPath;

  /// Stream of route changes
  Stream<String> get onRouteChange;

  /// Navigate to a new path
  void navigate(String path);

  /// Check if a path matches a pattern
  bool matches(String pattern, String path);

  /// Extract parameters from a path
  Map<String, String> extractParams(String pattern, String path);
}

/// Route definition
class SsrRoute {
  /// Route path pattern
  final String path;

  /// Route handler
  final Future<String> Function(Map<String, String> params) handler;

  /// Route metadata
  final Map<String, dynamic> metadata;

  const SsrRoute({
    required this.path,
    required this.handler,
    this.metadata = const {},
  });
}

/// Base implementation of SsrRouter
abstract class SsrRouterBase implements SsrRouter {
  @override
  String get currentPath;

  @override
  Stream<String> get onRouteChange;

  @override
  void navigate(String path);

  @override
  bool matches(String pattern, String path) {
    final regexPattern = pattern
        .replaceAll(':', r'([^/]+)')
        .replaceAll('/', r'\/');
    final regex = RegExp('^$regexPattern\$');
    return regex.hasMatch(path);
  }

  @override
  Map<String, String> extractParams(String pattern, String path) {
    final params = <String, String>{};
    final patternParts = pattern.split('/');
    final pathParts = path.split('/');

    for (var i = 0; i < patternParts.length; i++) {
      if (patternParts[i].startsWith(':')) {
        final paramName = patternParts[i].substring(1);
        params[paramName] = pathParts[i];
      }
    }

    return params;
  }
}
