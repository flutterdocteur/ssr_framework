# API Reference - ssr_router

Routing文件系统 pour le framework.

## Classes

### `FileRouter`

Découverte automatique des routes depuis la structure de fichiers.

```dart
class FileRouter {
  final String pagesDir;
  
  FileRouter({this.pagesDir = 'lib/pages'});
  
  Future<List<SsrRoute>> discoverRoutes();
  List<SsrRoute> get routes;
}
```

**Propriétés :**

- `pagesDir` : Dossier contenant les pages (défaut: `lib/pages`)
- `routes` : Liste des routes découvertes

**Méthodes :**

- `discoverRoutes()` : Scanne le dossier et retourne les routes

**Convention de nommage :**

| Fichier | Route générée |
|---------|---------------|
| `home_page.dart` | `/` |
| `about_page.dart` | `/about` |
| `profile/[id]_page.dart` | `/profile/:id` |
| `blog/[slug]_page.dart` | `/blog/:slug` |
| `users/[id]/settings_page.dart` | `/users/:id/settings` |

**Exemple :**

```dart
final router = FileRouter(pagesDir: 'lib/pages');
final routes = await router.discoverRoutes();

for (final route in routes) {
  print('${route.path} -> ${route.handler}');
}
```

### `RouteRegistry`

Registre des routes avec matching et extraction de paramètres.

```dart
class RouteRegistry {
  void register(SsrRoute route);
  List<SsrRoute> get routes;
  SsrRoute? findRoute(String path);
  bool _matches(String pattern, String path);
  Map<String, String> extractParams(String pattern, String path);
}
```

**Méthodes :**

- `register(route)` : Enregistre une route
- `routes` : Liste des routes enregistrées
- `findRoute(path)` : Trouve la route correspondant au chemin
- `extractParams(pattern, path)` : Extrait les paramètres d'un chemin

**Exemple :**

```dart
final registry = RouteRegistry();

registry.register(SsrRoute(
  path: '/profile/:id',
  handler: (params) async => 'Profile ${params['id']}',
));

final route = registry.findRoute('/profile/123');
if (route != null) {
  final params = registry.extractParams(route.path, '/profile/123');
  print(params['id']); // '123'
}
```

## Patterns de route

### Routes statiques

```
/about          -> /about
/contact        -> /contact
/blog           -> /blog
```

### Routes dynamiques

```
/profile/:id    -> /profile/123
/blog/:slug     -> /blog/my-first-post
/users/:userId  -> /users/42
```

### Routes imbriquées

```
/users/:id/settings     -> /users/42/settings
/blog/:year/:month/:id  -> /blog/2024/01/123
```

## Utilisation avec SsrServer

```dart
import 'package:ssr_core/ssr_core.dart';
import 'package:ssr_server/ssr_server.dart';
import 'package:ssr_router/ssr_router.dart';

void main() async {
  final router = FileRouter();
  final routes = await router.discoverRoutes();
  
  final config = SsrConfig(name: 'My App');
  final server = SsrServer(config: config, routes: routes);
  await server.start();
}
```
