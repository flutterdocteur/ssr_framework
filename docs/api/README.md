# API Reference

Documentation complète de l'API du framework SSR.

## Packages

### Core
- [ssr_core](ssr_core.md) - Interfaces et types fondamentaux
  - `SsrApp`, `SsrPage`, `SsrConfig`
  - `SsrRouter`, `SsrRoute`
  - `SsrState`

### Server
- [ssr_server](ssr_server.md) - Serveur HTTP + SSR
  - `SsrServer` - Serveur principal
  - `TemplateEngine` - Moteur de templates Jinja
  - `StaticHandler` - Fichiers statiques
  - `SeoHandler` - SEO automatique

### Client
- [ssr_client](ssr_client.md) - Hydratation + routing client
  - `HydrationService` - Hydratation des données
  - `NavigationService` - Routing client-side
  - `ApiService` - Client HTTP
  - `MetaService` - Meta tags dynamiques

### Routing
- [ssr_router](ssr_router.md) - Routing文件系统
  - `FileRouter` - Découverte automatique des routes
  - `RouteRegistry` - Registre des routes

### Hydration
- [ssr_hydration](ssr_hydration.md) - Hydratation automatique
  - `HydrationEngine` - Sérialisation/désérialisation
  - `DataTransfer` - Transfert de données

### SEO
- [ssr_seo](ssr_seo.md) - SEO utilities
  - `SeoGenerator` - Sitemap et robots.txt
  - `MetaTags` - Balises meta HTML

### PWA
- [ssr_pwa](ssr_pwa.md) - PWA utilities
  - `ManifestGenerator` - Manifest.json
  - `ServiceWorkerGenerator` - Service worker

### CLI
- [ssr_cli](ssr_cli.md) - Outils en ligne de commande
  - `ssr create` - Créer un projet
  - `ssr generate` - Générer du code
  - `ssr build` - Build production
  - `ssr serve` - Démarrer le serveur

## Types principaux

### Configuration

```dart
SsrConfig({
  required String name,
  String baseUrl = 'http://localhost:3000',
  int port = 3000,
  bool devMode = false,
  String staticDir = 'public',
  String templatesDir = 'templates',
  bool enablePwa = true,
  bool enableSeo = true,
})
```

### Page

```dart
// Page statique
class HomePage extends SsrPageBase {
  HomePage() : super(
    path: '/',
    title: 'Accueil',
    description: 'Page d\'accueil',
  );
  
  @override
  Future<String> render(Map<String, dynamic> data) async { ... }
  
  @override
  Future<Map<String, dynamic>> getInitialData() async { ... }
}

// Page dynamique
class ProfilePage extends SsrDynamicPage {
  ProfilePage() : super(
    path: '/profile/:id',
    pattern: '/profile/:id',
    title: 'Profil',
  );
  
  @override
  Map<String, String> extractParams(String actualPath) { ... }
}
```

### Route

```dart
SsrRoute({
  required String path,
  required Future<String> Function(Map<String, String> params) handler,
  Map<String, dynamic> metadata = const {},
})
```

## Patterns courants

### Créer une application

```dart
import 'package:ssr_core/ssr_core.dart';
import 'package:ssr_server/ssr_server.dart';

void main() async {
  final config = SsrConfig(
    name: 'Mon App',
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

### Créer un composant

```dart
import 'package:angulardart/angulardart.dart';

@Component(
  selector: 'my-component',
  template: '''
    <div class="my-component">
      <h2>{{ title }}</h2>
      <p>{{ content }}</p>
    </div>
  ''',
)
class MyComponent {
  @Input()
  String title = '';
  
  @Input()
  String content = '';
}
```

### Créer un service

```dart
import 'package:angulardart/angulardart.dart';

@Injectable()
class MyService {
  Future<List<Map<String, dynamic>>> getData() async {
    // Récupérer les données
    return [];
  }
}
```

### Utiliser le routing

```dart
final nav = NavigationService();

nav.onRouteChange.listen((path) {
  print('Route: $path');
  // Charger le composant approprié
});

nav.navigate('/profile/1');
```

### Hydrater les données

```dart
// Serveur
final data = {'profiles': [...]};
final script = HydrationEngine().generateScriptTag(data);

// Client
final hydrated = HydrationService().hydrate();
final profiles = hydrated?['profiles'];
```

## Navigation

- [Retour à la documentation](../README.md)
- [Guides](../guides/quickstart.md)
- [Exemples](../examples/README.md)
