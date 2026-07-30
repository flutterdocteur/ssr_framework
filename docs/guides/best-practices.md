# Best Practices

Bonnes pratiques pour développer avec SSR Framework.

## Architecture

### Organisation des fichiers

```
lib/
├── pages/              # Pages SSR (une par fichier)
│   ├── home_page.dart
│   ├── profile_page.dart
│   └── about_page.dart
├── components/         # Composants AngularDart
│   ├── header_component.dart
│   ├── footer_component.dart
│   └── user_card_component.dart
└── services/           # Services (business logic)
    ├── api_service.dart
    ├── auth_service.dart
    └── database_service.dart
```

### Séparation des responsabilités

**Pages** : Gestion du routing et du rendu SSR
```dart
class ProfilePage extends SsrPageBase {
  @override
  Future<Map<String, dynamic>> getInitialData() async {
    // Récupérer les données pour le SSR
    return {'profile': await _db.getProfile(id)};
  }
}
```

**Composants** : UI interactive
```dart
@Component(
  selector: 'user-card',
  template: '<div>{{ user.name }}</div>',
)
class UserCardComponent {
  @Input()
  Map<String, dynamic> user = {};
}
```

**Services** : Logique métier
```dart
@Injectable()
class UserService {
  Future<User> getUser(int id) async {
    // Logique de récupération
  }
}
```

## Performance

### Code Splitting

Utilisez les imports différés pour les pages non critiques :

```dart
import 'profile_component.template.dart' deferred as profile_ng;

Future<void> _loadPage(String path) async {
  if (path.startsWith('/profile/')) {
    await profile_ng.loadLibrary();
    _loader.loadNextToLocation(
      profile_ng.ProfileComponentNgFactory,
      container!,
    );
  }
}
```

### Prefetching

Préchargez les données des liens visibles :

```dart
@override
void ngOnInit() {
  _prefetchObserver = IntersectionObserver(
    _onLinkVisible,
    {'rootMargin': '100px'},
  );
}

void _onLinkVisible(List entries, IntersectionObserver observer) {
  for (final entry in entries) {
    if (entry.isIntersecting == true) {
      final href = entry.target.getAttribute('href');
      if (href != null) {
        _api.prefetchProfile(id);
        observer.unobserve(entry.target);
      }
    }
  }
}
```

### Optimistic Updates

Mettez à jour l'UI avant la réponse API :

```dart
void toggleFollow() {
  // Mettre à jour l'UI immédiatement
  _store.dispatch(AppAction(AppActionType.optimisticFollow, profileId));
  
  // Puis faire l'appel API
  _api.followProfile(profileId).catchError((e) {
    // Rollback en cas d'erreur
    _store.dispatch(AppAction(AppActionType.rollbackProfile, previousProfile));
  });
}
```

## SEO

### Meta tags dynamiques

Mettez à jour les meta tags pour chaque page :

```dart
void _setupRouteListener() {
  _nav.onRouteChange.listen((path) {
    _meta.updateMeta(
      title: 'Page: $path',
      description: getDescriptionForPath(path),
      canonical: 'https://myapp.com$path',
    );
  });
}
```

### Sitemap automatique

Le framework génère automatiquement le sitemap.xml. Assurez-vous que toutes vos pages sont enregistrées :

```dart
final pages = [
  HomePage(),
  AboutPage(),
  ProfilePage(),  // Toutes les pages doivent être listées
];
```

### URLs canoniques

Toujours définir l'URL canonique pour éviter le contenu dupliqué :

```dart
<meta id="meta-canonical" rel="canonical" href="https://myapp.com/profile/1">
```

## Sécurité

### Validation des entrées

Validez toujours les données utilisateur :

```dart
app.post('/api/profile', (HttpRequest req, HttpResponse res) async {
  final body = await req.body;
  final name = body['name'] as String?;
  
  if (name == null || name.length < 3) {
    res.statusCode = 400;
    return {'error': 'Name must be at least 3 characters'};
  }
  
  // Traiter les données
});
```

### Headers de sécurité

Ajoutez des headers de sécurité :

```dart
app.all('*', (HttpRequest req, HttpResponse res) {
  res.headers.add('X-Frame-Options', 'DENY');
  res.headers.add('X-Content-Type-Options', 'nosniff');
  res.headers.add('X-XSS-Protection', '1; mode=block');
  res.headers.add('Referrer-Policy', 'strict-origin-when-cross-origin');
  return null;
});
```

### Rate Limiting

Protégez vos API contre les abus :

```dart
final _requestCounts = <String, List<int>>{};

app.all('*', (HttpRequest req, HttpResponse res) {
  final ip = req.connectionInfo!.remoteAddress.address;
  final now = DateTime.now().millisecondsSinceEpoch;
  
  _requestCounts.putIfAbsent(ip, () => []);
  _requestCounts[ip]!.removeWhere((t) => now - t > 60000);
  
  if (_requestCounts[ip]!.length >= 100) {
    res.statusCode = 429;
    return {'error': 'Too many requests'};
  }
  
  _requestCounts[ip]!.add(now);
  return null;
});
```

## Tests

### Tests unitaires

Testez vos services et composants :

```dart
group('UserService', () {
  late UserService service;
  
  setUp(() {
    service = UserService();
  });
  
  test('getUser returns user', () async {
    final user = await service.getUser(1);
    expect(user, isNotNull);
    expect(user['id'], equals(1));
  });
});
```

### Tests d'intégration

Testez vos routes API :

```dart
test('GET /api/profiles returns 200', () async {
  final response = await http.get(Uri.parse('http://localhost:3000/api/profiles'));
  expect(response.statusCode, equals(200));
});
```

## Déploiement

### Variables d'environnement

Utilisez des variables d'environnement pour la configuration :

```dart
final config = SsrConfig(
  port: int.parse(Platform.environment['PORT'] ?? '3000'),
  baseUrl: Platform.environment['BASE_URL'] ?? 'http://localhost:3000',
  devMode: Platform.environment['DEV_MODE'] == 'true',
);
```

### Build de production

Toujours build en mode release pour la production :

```bash
ssr build --release
```

### Monitoring

Ajoutez des logs et des métriques :

```dart
app.all('*', (HttpRequest req, HttpResponse res) {
  final timestamp = DateTime.now().toIso8601String();
  print('[$timestamp] ${req.method} ${req.uri.path}');
  return null;
});
```

## Conventions de code

### Nommage

- **Fichiers** : snake_case (`user_card_component.dart`)
- **Classes** : PascalCase (`UserCardComponent`)
- **Variables** : camelCase (`userName`)
- **Constantes** : UPPER_SNAKE_CASE (`MAX_RETRY_COUNT`)

### Commentaires

Commentez le "pourquoi", pas le "quoi" :

```dart
// Mauvais
// Incrémente le compteur
count++;

// Bon
// Incrémente le compteur pour tracker les tentatives de connexion
count++;
```

### Documentation

Documentez les API publiques :

```dart
/// Récupère un utilisateur par son ID.
///
/// Retourne `null` si l'utilisateur n'existe pas.
///
/// Exemple:
/// ```dart
/// final user = await userService.getUser(1);
/// ```
Future<User?> getUser(int id) async {
  // ...
}
```

## Ressources

- [Configuration avancée](configuration.md)
- [Troubleshooting](troubleshooting.md)
- [API Reference](../api/README.md)
