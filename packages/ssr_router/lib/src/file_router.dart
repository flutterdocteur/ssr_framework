import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:ssr_core/ssr_core.dart';
import 'route_registry.dart';

/// File-based router that automatically discovers routes from file structure
class FileRouter {
  final String pagesDir;
  final RouteRegistry _registry = RouteRegistry();

  FileRouter({this.pagesDir = 'lib/pages'});

  /// Discover and register routes from file structure
  Future<List<SsrRoute>> discoverRoutes() async {
    final routes = <SsrRoute>[];
    final dir = Directory(pagesDir);

    if (!await dir.exists()) {
      print('Pages directory not found: $pagesDir');
      return routes;
    }

    await for (final entity in dir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('_page.dart')) {
        final route = _fileToRoute(entity);
        if (route != null) {
          routes.add(route);
          _registry.register(route);
        }
      }
    }

    return routes;
  }

  SsrRoute? _fileToRoute(File file) {
    final relativePath = p.relative(file.path, from: pagesDir);
    final pathParts = p.split(relativePath);
    
    // Convert file path to route path
    // e.g., "profile/[id]_page.dart" -> "/profile/:id"
    var routePath = '/' + pathParts
        .map((part) => part
            .replaceAll('_page.dart', '')
            .replaceAll(RegExp(r'\[(\w+)\]'), ':\$1'))
        .join('/');

    // Handle index pages
    if (routePath.endsWith('/index')) {
      routePath = routePath.replaceAll('/index', '');
    }

    if (routePath.isEmpty) {
      routePath = '/';
    }

    return SsrRoute(
      path: routePath,
      handler: (params) async {
        // TODO: Load and execute page handler
        return '<html><body>Page: $routePath</body></html>';
      },
    );
  }

  /// Get registered routes
  List<SsrRoute> get routes => _registry.routes;
}
