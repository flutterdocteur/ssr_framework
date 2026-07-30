import 'dart:async';
import 'dart:html';
import 'package:angulardart/angulardart.dart';
import 'package:ssr_core/ssr_core.dart';

/// Navigation service for client-side routing
@Injectable()
class NavigationService implements SsrRouter {
  final _routeController = StreamController<String>.broadcast();

  @override
  Stream<String> get onRouteChange => _routeController.stream;

  String _currentPath = '/';

  @override
  String get currentPath => _currentPath;

  NavigationService() {
    _currentPath = window.location.pathname ?? '/';
    _setupLinkInterceptor();
    _setupPopStateListener();
  }

  void _setupLinkInterceptor() {
    document.addEventListener('click', (event) {
      final target = event.target as Element?;
      final anchor = target?.closest('a');

      if (anchor != null) {
        final href = anchor.getAttribute('href');
        if (href != null &&
            href.startsWith('/') &&
            !href.startsWith('/static') &&
            !href.startsWith('/api')) {
          event.preventDefault();
          navigate(href);
        }
      }
    });
  }

  void _setupPopStateListener() {
    window.onPopState.listen((_) {
      _currentPath = window.location.pathname ?? '/';
      _routeController.add(_currentPath);
    });
  }

  @override
  void navigate(String path) {
    if (path == _currentPath) return;

    window.history.pushState(null, '', path);
    _currentPath = path;
    _routeController.add(path);
  }

  void dispose() {
    _routeController.close();
  }
}
