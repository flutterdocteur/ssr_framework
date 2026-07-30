# Configuration avancée

Ce guide couvre les options de configuration avancées du framework SSR.

## Configuration du serveur

### SsrConfig

```dart
final config = SsrConfig(
  name: 'Mon App',
  baseUrl: 'https://monapp.com',
  port: 3000,
  devMode: false,
  staticDir: 'public',
  templatesDir: 'templates',
  enablePwa: true,
  enableSeo: true,
);
```

### Options

| Option | Type | Défaut | Description |
|--------|------|--------|-------------|
| `name` | String | requis | Nom de l'application |
| `baseUrl` | String | `http://localhost:3000` | URL de base |
| `port` | int | `3000` | Port du serveur |
| `devMode` | bool | `false` | Mode développement |
| `staticDir` | String | `public` | Dossier fichiers statiques |
| `templatesDir` | String | `templates` | Dossier templates |
| `enablePwa` | bool | `true` | Activer PWA |
| `enableSeo` | bool | `true` | Activer SEO |

## Configuration des routes

### Routes statiques

```dart
class HomePage extends SsrPageBase {
  HomePage() : super(
    path: '/',
    title: 'Accueil',
    description: 'Page d\'accueil',
  );
}
```

### Routes dynamiques

```dart
class ProfilePage extends SsrDynamicPage {
  ProfilePage() : super(
    path: '/profile/:id',
    pattern: '/profile/:id',
    title: 'Profil',
  );

  @override
  Map<String, String> extractParams(String actualPath) {
    final match = RegExp(r'/profile/(\d+)').firstMatch(actualPath);
    if (match != null) {
      return {'id': match.group(1)!};
    }
    return {};
  }
}
```

### Routes imbriquées

```dart
class UserSettingsPage extends SsrPageBase {
  UserSettingsPage() : super(
    path: '/user/:userId/settings',
    title: 'Paramètres',
  );
}
```

## Configuration du client

### Navigation

```dart
@Injectable()
class NavigationService {
  void navigate(String path) {
    window.history.pushState(null, '', path);
    _routeController.add(path);
  }
}
```

### Prefetching

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
      }
    }
  }
}
```

### Code splitting

```dart
import 'profile_component.template.dart' deferred as profile_ng;

Future<void> _loadPage(String path) async {
  if (path.startsWith('/profile/')) {
    await profile_ng.loadLibrary();
    _currentPageRef = _loader.loadNextToLocation(
      profile_ng.ProfileComponentNgFactory,
      pageContainer!,
    );
  }
}
```

## Configuration SEO

### Meta tags dynamiques

```dart
@Injectable()
class MetaService {
  void updateMeta({
    required String title,
    String? description,
    String? canonical,
    Map<String, String>? ogTags,
  }) {
    document.title = title;
    _setMetaContent('meta-description', description);
    _setMetaContent('meta-canonical', canonical);
  }
}
```

### Sitemap automatique

```dart
class SeoHandler {
  String generateSitemap() {
    final buffer = StringBuffer();
    buffer.writeln('<?xml version="1.0" encoding="UTF-8"?>');
    buffer.writeln('<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">');

    for (final page in pages) {
      buffer.writeln('  <url>');
      buffer.writeln('    <loc>$baseUrl${page.path}</loc>');
      buffer.writeln('    <priority>${_getPriority(page.path)}</priority>');
      buffer.writeln('  </url>');
    }

    buffer.writeln('</urlset>');
    return buffer.toString();
  }
}
```

## Configuration PWA

### Manifest

```dart
class ManifestGenerator {
  static String generate({
    required String name,
    required String shortName,
    required String startUrl,
    required String themeColor,
  }) {
    final manifest = {
      'name': name,
      'short_name': shortName,
      'start_url': startUrl,
      'display': 'standalone',
      'theme_color': themeColor,
      'background_color': '#ffffff',
    };
    return jsonEncode(manifest);
  }
}
```

### Service Worker

```dart
class ServiceWorkerGenerator {
  static String generate({
    String cacheName = 'app-v1',
    List<String> staticAssets = const [],
  }) {
    return '''
const CACHE_NAME = '$cacheName';
const STATIC_ASSETS = ${jsonEncode(staticAssets)};

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll(STATIC_ASSETS);
    })
  );
});

self.addEventListener('fetch', (event) => {
  // Cache-first strategy
  event.respondWith(
    caches.match(event.request).then((cached) => {
      return cached || fetch(event.request);
    })
  );
});
''';
  }
}
```

## Configuration de la base de données

### SQLite

```dart
class DatabaseService {
  late Database _db;

  void init() {
    _db = sqlite3.open('data/app.db');
    _createTables();
  }

  void _createTables() {
    _db.execute('''
      CREATE TABLE IF NOT EXISTS profiles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        bio TEXT NOT NULL
      )
    ''');
  }
}
```

### Migrations

```dart
class MigrationService {
  void migrate(Database db) {
    final version = _getVersion(db);
    
    if (version < 2) {
      db.execute('ALTER TABLE profiles ADD COLUMN email TEXT');
      _setVersion(db, 2);
    }
    
    if (version < 3) {
      db.execute('CREATE TABLE posts (...)');
      _setVersion(db, 3);
    }
  }
}
```

## Configuration des middleware

### Logging

```dart
app.all('*', (HttpRequest req, HttpResponse res) {
  final timestamp = DateTime.now().toIso8601String();
  print('[$timestamp] ${req.method} ${req.uri.path}');
  return null;
});
```

### CORS

```dart
app.all('*', (HttpRequest req, HttpResponse res) {
  res.headers.add('Access-Control-Allow-Origin', '*');
  res.headers.add('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
  res.headers.add('Access-Control-Allow-Headers', 'Content-Type');
  return null;
});
```

### Authentication

```dart
app.all('*', (HttpRequest req, HttpResponse res) {
  if (req.uri.path.startsWith('/api/') && !_isAuthenticated(req)) {
    res.statusCode = 401;
    return {'error': 'Unauthorized'};
  }
  return null;
});

bool _isAuthenticated(HttpRequest req) {
  final token = req.headers.value('Authorization');
  return token != null && _validateToken(token);
}
```

### Rate limiting

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

## Configuration du cache

### Cache serveur

```dart
final _cache = <String, _CacheEntry>{};

app.get('/api/data', (HttpRequest req, HttpResponse res) async {
  final cacheKey = 'data';
  
  if (_cache.containsKey(cacheKey) && !_cache[cacheKey]!.isExpired()) {
    return _cache[cacheKey]!.data;
  }
  
  final data = await _fetchData();
  _cache[cacheKey] = _CacheEntry(data, Duration(minutes: 5));
  
  return data;
});
```

### Cache client

```dart
class CacheService {
  final _cache = <String, dynamic>{};

  dynamic get(String key) {
    return _cache[key];
  }

  void set(String key, dynamic value, {Duration? ttl}) {
    _cache[key] = value;
    if (ttl != null) {
      Future.delayed(ttl, () => _cache.remove(key));
    }
  }
}
```

## Configuration des tests

### Tests unitaires

```dart
import 'package:test/test.dart';

void main() {
  group('DatabaseService', () {
    late DatabaseService dbService;

    setUp(() {
      dbService = DatabaseService();
      dbService.init();
    });

    tearDown(() {
      dbService.dispose();
    });

    test('getProfiles returns profiles', () async {
      final profiles = await dbService.getProfiles();
      expect(profiles, isNotEmpty);
    });
  });
}
```

### Tests d'intégration

```dart
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('GET /api/profiles returns 200', () async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/profiles'));
    expect(response.statusCode, equals(200));
  });
}
```

## Variables d'environnement

### Fichier .env

```bash
# Serveur
PORT=3000
BASE_URL=http://localhost:3000
DEV_MODE=true

# Base de données
DATABASE_PATH=data/app.db

# API externes
API_KEY=your-api-key
API_SECRET=your-api-secret

# Logging
LOG_LEVEL=info
LOG_FILE=logs/app.log
```

### Lecture des variables

```dart
import 'dart:io';

class Env {
  static String get port => Platform.environment['PORT'] ?? '3000';
  static String get baseUrl => Platform.environment['BASE_URL'] ?? 'http://localhost:3000';
  static bool get devMode => Platform.environment['DEV_MODE'] == 'true';
  static String get databasePath => Platform.environment['DATABASE_PATH'] ?? 'data/app.db';
}
```

## Prochaines étapes

- [Best practices](best-practices.md)
- [Troubleshooting](troubleshooting.md)
- [API Reference](../api/README.md)
