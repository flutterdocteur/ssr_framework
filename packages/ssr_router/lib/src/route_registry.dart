import 'package:ssr_core/ssr_core.dart';

/// Registry for managing routes
class RouteRegistry {
  final List<SsrRoute> _routes = [];

  /// Register a new route
  void register(SsrRoute route) {
    _routes.add(route);
  }

  /// Get all registered routes
  List<SsrRoute> get routes => List.unmodifiable(_routes);

  /// Find a route by path
  SsrRoute? findRoute(String path) {
    for (final route in _routes) {
      if (_matches(route.path, path)) {
        return route;
      }
    }
    return null;
  }

  /// Check if a path matches a pattern
  bool _matches(String pattern, String path) {
    final regexPattern = pattern
        .replaceAll(':', r'([^/]+)')
        .replaceAll('/', r'\/');
    final regex = RegExp('^$regexPattern\$');
    return regex.hasMatch(path);
  }

  /// Extract parameters from a path
  Map<String, String> extractParams(String pattern, String path) {
    final params = <String, String>{};
    final patternParts = pattern.split('/');
    final pathParts = path.split('/');

    for (var i = 0; i < patternParts.length; i++) {
      if (patternParts[i].startsWith(':')) {
        final paramName = patternParts[i].substring(1);
        if (i < pathParts.length) {
          params[paramName] = pathParts[i];
        }
      }
    }

    return params;
  }
}
