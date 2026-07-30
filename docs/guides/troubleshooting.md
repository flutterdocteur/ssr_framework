# Troubleshooting

Guide de résolution des problèmes courants.

## Erreurs de compilation

### `Error: Could not find package ssr_core`

**Cause** : Les dépendances ne sont pas installées.

**Solution** :
```bash
dart pub get
```

### `Error: AngularDart requires build_runner`

**Cause** : Le code AngularDart n'a pas été généré.

**Solution** :
```bash
dart run build_runner build --delete-conflicting-outputs
```

### `Error: Part files not found`

**Cause** : Les fichiers `.part.js` du code splitting ne sont pas dans `public/`.

**Solution** :
```bash
# Copier tous les fichiers générés
cp -r .dart_tool/build/generated/*/web/* public/
```

## Erreurs de runtime

### `Error: Failed to load libsqlite3.so`

**Cause** : La bibliothèque SQLite n'est pas installée.

**Solution** :
```bash
# Ubuntu/Debian
sudo apt-get install libsqlite3-dev

# macOS
brew install sqlite

# Windows
# Télécharger depuis https://www.sqlite.org/download.html
```

### `Error: Port already in use`

**Cause** : Le port 3000 est déjà utilisé.

**Solution** :
```bash
# Utiliser un autre port
ssr serve --port 8080

# Ou arrêter le processus existant
lsof -ti:3000 | xargs kill -9
```

### `Error: Template not found`

**Cause** : Le fichier template n'existe pas ou le chemin est incorrect.

**Solution** :
1. Vérifier que le fichier existe dans `templates/pages/`
2. Vérifier le chemin dans `SsrConfig.templatesDir`
3. Vérifier l'extension du fichier (`.html`)

### `Error: Hydration failed`

**Cause** : Les données d'hydratation sont manquantes ou invalides.

**Solution** :
1. Vérifier que `<script id="initial-data">` est présent dans le HTML
2. Vérifier que les données sont en JSON valide
3. Vérifier la console pour des erreurs de parsing

## Erreurs de routing

### `Error: 404 Not Found`

**Cause** : La route n'est pas enregistrée.

**Solution** :
1. Vérifier que la page est dans la liste `pages` du serveur
2. Vérifier le chemin de la page (`path: '/about'`)
3. Redémarrer le serveur

### `Error: Navigation not working`

**Cause** : Le `NavigationService` n'est pas injecté correctement.

**Solution** :
```dart
@GenerateInjector([
  ClassProvider(NavigationService),
  // ...
])
final appInjector = ngMain.appInjector$Injector;
```

## Erreurs de performance

### `Slow initial load`

**Causes possibles** :
1. Bundle JavaScript trop gros
2. Pas de code splitting
3. Pas de prefetching

**Solutions** :
1. Utiliser les imports différés :
```dart
import 'page.template.dart' deferred as page_ng;
```

2. Activer le prefetching :
```dart
_prefetchObserver = IntersectionObserver(
  _onLinkVisible,
  {'rootMargin': '100px'},
);
```

3. Optimiser les images :
```html
<img src="/static/image.webp" loading="lazy">
```

### `Slow navigation`

**Causes possibles** :
1. Pas de cache
2. Appels API lents
3. Composants lourds

**Solutions** :
1. Utiliser le cache :
```dart
final _cache = <String, dynamic>{};

Future<void> fetchData(String key) async {
  if (_cache.containsKey(key)) {
    return _cache[key];
  }
  final data = await _api.get(key);
  _cache[key] = data;
  return data;
}
```

2. Utiliser les optimistic updates :
```dart
_store.dispatch(AppAction(AppActionType.optimisticFollow, id));
await _api.followProfile(id);
```

## Erreurs SEO

### `Sitemap.xml not generated`

**Cause** : SEO désactivé dans la configuration.

**Solution** :
```dart
final config = SsrConfig(
  enableSeo: true,  // Activer le SEO
);
```

### `Meta tags not updating`

**Cause** : Le `MetaService` n'est pas appelé lors des changements de route.

**Solution** :
```dart
_nav.onRouteChange.listen((path) {
  _meta.updateMeta(
    title: getTitle(path),
    description: getDescription(path),
  );
});
```

## Erreurs PWA

### `Service Worker not registering`

**Causes possibles** :
1. Pas en HTTPS (requis en production)
2. Fichier `sw.js` manquant
3. Erreur dans le service worker

**Solutions** :
1. Utiliser HTTPS en production
2. Vérifier que `sw.js` est dans `public/`
3. Vérifier la console pour des erreurs

### `Manifest not found`

**Cause** : Le fichier `manifest.json` est manquant.

**Solution** :
1. Générer le manifest :
```dart
final manifest = ManifestGenerator.generate(
  name: 'My App',
  shortName: 'App',
  startUrl: '/',
  themeColor: '#2c3e50',
  backgroundColor: '#ffffff',
);
await File('public/manifest.json').writeAsString(manifest);
```

2. Ajouter le lien dans le HTML :
```html
<link rel="manifest" href="/manifest.json">
```

## Erreurs de déploiement

### `Connection refused`

**Cause** : Le serveur n'est pas démarré ou le port est bloqué.

**Solution** :
1. Vérifier que le serveur est démarré :
```bash
ssr serve
```

2. Vérifier le pare-feu :
```bash
sudo ufw allow 3000
```

3. Vérifier que le serveur écoute sur `0.0.0.0` :
```dart
await app.listen(port, '0.0.0.0');
```

### `Static files not loading`

**Cause** : Les fichiers statiques ne sont pas dans `public/`.

**Solution** :
```bash
# Copier les fichiers générés
cp -r .dart_tool/build/generated/*/web/* public/

# Vérifier que les fichiers existent
ls public/
```

## Debugging

### Activer les logs détaillés

```dart
final config = SsrConfig(
  devMode: true,  // Active les logs détaillés
);
```

### Inspecter les requêtes

```dart
app.all('*', (HttpRequest req, HttpResponse res) {
  print('Request: ${req.method} ${req.uri.path}');
  print('Headers: ${req.headers}');
  print('Body: ${req.body}');
  return null;
});
```

### Inspecter le state

```dart
_store.state$.listen((state) {
  print('State changed: $state');
});
```

### Utiliser Chrome DevTools

1. **Network** : Vérifier les requêtes API et les fichiers statiques
2. **Console** : Vérifier les erreurs JavaScript
3. **Application** : Vérifier le service worker et le cache
4. **Lighthouse** : Analyser les performances et le SEO

## Ressources

- [Best practices](best-practices.md)
- [FAQ](../faq.md)
- [Documentation API](../api/README.md)
