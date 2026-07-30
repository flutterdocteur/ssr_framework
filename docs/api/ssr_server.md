# API Reference - ssr_server

Serveur HTTP avec SSR pour le framework.

## Classes

### `SsrServer`

Serveur principal qui gère le routing et le rendu SSR.

```dart
class SsrServer {
  final SsrConfig config;
  final List<SsrPage> pages;
  
  SsrServer({
    required this.config,
    required this.pages,
  });
  
  Future<void> start();
  Future<void> stop();
}
```

**Méthodes :**

- `start()` : Démarre le serveur HTTP
- `stop()` : Arrête le serveur

**Exemple :**

```dart
final server = SsrServer(
  config: SsrConfig(
    name: 'My App',
    port: 3000,
  ),
  pages: [HomePage(), AboutPage()],
);

await server.start();
```

### `TemplateEngine`

Moteur de templates Jinja pour le rendu HTML.

```dart
class TemplateEngine {
  final String templatesDir;
  
  TemplateEngine(this.templatesDir);
  
  Future<void> init();
  String render(String templateName, [Map<String, dynamic>? context]);
}
```

**Méthodes :**

- `init()` : Initialise le moteur de templates
- `render(templateName, context)` : Rend un template avec le contexte fourni

**Exemple :**

```dart
final engine = TemplateEngine('templates');
await engine.init();

final html = engine.render('pages/home.html', {
  'title': 'Accueil',
  'items': [1, 2, 3],
});
```

### `StaticHandler`

Gestionnaire de fichiers statiques (CSS, JS, images).

```dart
class StaticHandler {
  final String staticDir;
  
  StaticHandler(this.staticDir);
  
  dynamic handle(HttpRequest req, HttpResponse res);
}
```

**Fonctionnalités :**

- Détection automatique du Content-Type
- Support des fichiers `.js`, `.css`, `.json`, `.svg`, `.png`, `.jpg`, `.ico`
- Gestion des erreurs 404

### `SeoHandler`

Génération automatique de fichiers SEO.

```dart
class SeoHandler {
  final String baseUrl;
  final List<SsrPage> pages;
  
  SeoHandler(this.baseUrl, this.pages);
  
  String generateSitemap();
  String generateRobotsTxt();
}
```

**Méthodes :**

- `generateSitemap()` : Génère le contenu de `sitemap.xml`
- `generateRobotsTxt()` : Génère le contenu de `robots.txt`

## Routes automatiques

Le serveur crée automatiquement les routes suivantes :

| Route | Description |
|-------|-------------|
| `/` | Page d'accueil |
| `/about` | Page à propos |
| `/sitemap.xml` | Plan du site SEO |
| `/robots.txt` | Instructions pour les robots |
| `/manifest.json` | Manifest PWA |
| `/static/*` | Fichiers statiques |

## Middleware

Le serveur inclut des middleware par défaut :

1. **Static files** : Sert les fichiers de `public/`
2. **Logging** : Log toutes les requêtes
3. **SEO** : Routes SEO automatiques (si activé)
4. **PWA** : Manifest et service worker (si activé)

## Configuration

```dart
final config = SsrConfig(
  name: 'My App',
  baseUrl: 'https://myapp.com',
  port: 3000,
  devMode: false,
  staticDir: 'public',
  templatesDir: 'templates',
  enablePwa: true,
  enableSeo: true,
);
```

## Utilisation complète

```dart
import 'package:ssr_core/ssr_core.dart';
import 'package:ssr_server/ssr_server.dart';

void main() async {
  final config = SsrConfig(
    name: 'My App',
    port: 3000,
  );

  final pages = [
    HomePage(),
    AboutPage(),
  ];

  final server = SsrServer(config: config, pages: pages);
  await server.start();
}
```
