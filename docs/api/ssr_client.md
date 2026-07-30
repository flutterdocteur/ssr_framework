# API Reference - ssr_client

Client-side hydration et routing pour le framework.

## Services

### `HydrationService`

Service d'hydratation des données serveur vers le client.

```dart
class HydrationService {
  Map<String, dynamic>? hydrate();
}
```

**Méthodes :**

- `hydrate()` : Lit les données du `<script id="initial-data">` et les désérialise

**Exemple :**

```dart
final hydration = HydrationService();
final data = hydration.hydrate();
if (data != null) {
  // Utiliser les données hydratées
  final profiles = data['data'] as List;
}
```

### `NavigationService`

Service de routing client-side avec interception de clics.

```dart
@Injectable()
class NavigationService implements SsrRouter {
  String get currentPath;
  Stream<String> get onRouteChange;
  
  void navigate(String path);
  void dispose();
}
```

**Propriétés :**

- `currentPath` : Chemin actuel
- `onRouteChange` : Stream des changements de route

**Méthodes :**

- `navigate(path)` : Navigue vers un nouveau chemin avec `pushState`
- `dispose()` : Libère les ressources

**Fonctionnalités :**

- Interception automatique des clics sur `<a href="/...">`
- Gestion du bouton retour/forward (popstate)
- Exclusion des liens `/static/*` et `/api/*`

**Exemple :**

```dart
final nav = NavigationService();

nav.onRouteChange.listen((path) {
  print('Route changed to: $path');
  // Charger le composant approprié
});

nav.navigate('/profile/1');
```

### `ApiService`

Client HTTP pour les appels API.

```dart
@Injectable()
class ApiService {
  ApiService(Client http);
  
  Future<Map<String, dynamic>> get(String path);
  Future<Map<String, dynamic>> post(String path, [Map<String, dynamic>? data]);
}
```

**Méthodes :**

- `get(path)` : Requête GET vers l'API
- `post(path, data)` : Requête POST vers l'API

**Exemple :**

```dart
final api = ApiService(BrowserClient());

final profiles = await api.get('/api/profiles');
final result = await api.post('/api/profile/1/follow');
```

### `MetaService`

Service de gestion des meta tags dynamiques.

```dart
@Injectable()
class MetaService {
  void updateMeta({
    required String title,
    String? description,
    String? canonical,
    Map<String, String>? ogTags,
  });
}
```

**Méthodes :**

- `updateMeta(...)` : Met à jour les meta tags pour le SEO

**Paramètres :**

- `title` : Titre de la page
- `description` : Description meta
- `canonical` : URL canonique
- `ogTags` : Tags Open Graph (og:title, og:description, etc.)

**Exemple :**

```dart
final meta = MetaService();

meta.updateMeta(
  title: 'Profil - Mon App',
  description: 'Voir le profil utilisateur',
  canonical: 'https://myapp.com/profile/1',
  ogTags: {
    'title': 'Profil utilisateur',
    'description': 'Voir le profil',
    'url': 'https://myapp.com/profile/1',
  },
);
```

## Configuration DI

```dart
@GenerateInjector([
  ClassProvider(NavigationService),
  ClassProvider(ApiService),
  ClassProvider(MetaService),
  ClassProvider(Client, useClass: BrowserClient),
])
final appInjector = ngMain.appInjector$Injector;
```

## Utilisation dans un composant

```dart
@Component(
  selector: 'app-root',
  template: '''
    <main>
      <home-page *ngIf="currentRoute == '/'"></home-page>
      <profile-page *ngIf="currentRoute.startsWith('/profile/')"></profile-page>
    </main>
  ''',
  directives: [NgIf, HomePage, ProfilePage],
)
class AppComponent implements OnInit {
  final NavigationService _nav;
  final MetaService _meta;
  
  String currentRoute = '/';
  
  AppComponent(this._nav, this._meta);
  
  @override
  void ngOnInit() {
    currentRoute = _nav.currentPath;
    _nav.onRouteChange.listen((path) {
      currentRoute = path;
      _meta.updateMeta(title: 'Page: $path');
    });
  }
}
```
