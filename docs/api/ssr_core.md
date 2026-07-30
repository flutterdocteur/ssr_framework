# API Reference - ssr_core

Interfaces et types fondamentaux du framework SSR.

## Classes

### `SsrApp`

Interface abstraite pour une application SSR.

```dart
abstract class SsrApp {
  SsrConfig get config;
  List<SsrPage> get pages;
  Future<void> init();
  Future<void> dispose();
}
```

### `SsrAppBase`

Implémentation de base de `SsrApp`.

```dart
abstract class SsrAppBase implements SsrApp {
  SsrAppBase(SsrConfig config);
  
  @override
  Future<void> init() async;
  
  @override
  Future<void> dispose() async;
}
```

### `SsrPage`

Interface pour une page SSR statique.

```dart
abstract class SsrPage {
  String get path;
  String get title;
  String? get description;
  Future<String> render(Map<String, dynamic> data);
  Future<Map<String, dynamic>> getInitialData();
}
```

### `SsrPageBase`

Implémentation de base de `SsrPage`.

```dart
abstract class SsrPageBase implements SsrPage {
  SsrPageBase({
    required String path,
    required String title,
    String? description,
  });
  
  @override
  Future<Map<String, dynamic>> getInitialData() async => {};
}
```

### `SsrDynamicPage`

Page avec paramètres de route dynamiques.

```dart
abstract class SsrDynamicPage extends SsrPageBase {
  final String pattern;
  
  SsrDynamicPage({
    required String path,
    required String title,
    String? description,
    required this.pattern,
  });
  
  Map<String, String> extractParams(String actualPath);
}
```

### `SsrConfig`

Configuration de l'application.

```dart
class SsrConfig {
  final String name;
  final String baseUrl;
  final int port;
  final bool devMode;
  final String staticDir;
  final String templatesDir;
  final bool enablePwa;
  final bool enableSeo;
  
  const SsrConfig({
    required this.name,
    this.baseUrl = 'http://localhost:3000',
    this.port = 3000,
    this.devMode = false,
    this.staticDir = 'public',
    this.templatesDir = 'lib/templates',
    this.enablePwa = true,
    this.enableSeo = true,
  });
  
  SsrConfig copyWith({...});
}
```

### `SsrRouter`

Interface pour le routing.

```dart
abstract class SsrRouter {
  String get currentPath;
  Stream<String> get onRouteChange;
  void navigate(String path);
  bool matches(String pattern, String path);
  Map<String, String> extractParams(String pattern, String path);
}
```

### `SsrRoute`

Définition d'une route.

```dart
class SsrRoute {
  final String path;
  final Future<String> Function(Map<String, String> params) handler;
  final Map<String, dynamic> metadata;
  
  const SsrRoute({
    required this.path,
    required this.handler,
    this.metadata = const {},
  });
}
```

### `SsrState<T>`

Interface pour le state management.

```dart
abstract class SsrState<T> {
  T get state;
  Stream<T> get state$;
  void dispatch(dynamic action);
}
```

## Utilisation

```dart
import 'package:ssr_core/ssr_core.dart';

class MyApp extends SsrAppBase {
  MyApp() : super(SsrConfig(name: 'My App'));
  
  @override
  List<SsrPage> get pages => [HomePage(), AboutPage()];
}
```
