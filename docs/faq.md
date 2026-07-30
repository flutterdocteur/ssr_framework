# FAQ - Questions fréquentes

## Général

### Qu'est-ce que SSR Framework ?

SSR Framework est un framework Dart moderne inspiré de Next.js pour créer des applications web avec Server-Side Rendering (SSR) et hydratation automatique. Il combine :
- **Alfred** pour le serveur HTTP
- **AngularDart** pour le client
- **Jinja** pour les templates
- **SQLite** pour la base de données

### Pourquoi utiliser SSR Framework ?

- **Performance** : SSR pour un chargement rapide et SEO optimisé
- **UX** : Navigation SPA fluide après l'hydratation
- **Productivité** : CLI pour générer du code, routing文件系统
- **Moderne** : Code splitting, prefetching, PWA support

### Quelles sont les alternatives ?

- **Next.js** (JavaScript/TypeScript)
- **Nuxt.js** (Vue.js)
- **SvelteKit** (Svelte)
- **Angular Universal** (Angular)

SSR Framework est l'équivalent Dart de ces frameworks.

## Installation

### Quels sont les prérequis ?

- Dart SDK 3.12.2 ou supérieur
- Git (optionnel)
- libsqlite3-dev (pour la base de données)

### Comment installer sur Windows ?

1. Installer Dart depuis [dart.dev/get-dart](https://dart.dev/get-dart)
2. Installer SQLite depuis [sqlite.org/download.html](https://www.sqlite.org/download.html)
3. Cloner le repository et installer les dépendances

### Comment installer sur macOS ?

```bash
# Installer Dart
brew install dart

# SQLite est inclus par défaut
# Installer le framework
git clone https://github.com/yourusername/ssr_framework.git
cd ssr_framework
./install.sh
```

### Comment installer sur Linux ?

```bash
# Ubuntu/Debian
sudo apt-get install dart libsqlite3-dev

# Fedora
sudo dnf install dart sqlite-devel

# Installer le framework
git clone https://github.com/yourusername/ssr_framework.git
cd ssr_framework
./install.sh
```

## Utilisation

### Comment créer un nouveau projet ?

```bash
ssr create my-app
cd my-app
dart pub get
ssr serve
```

### Comment ajouter une page ?

```bash
ssr generate page contact
```

Puis modifier :
- `lib/pages/contact_page.dart`
- `templates/pages/contact.html`
- `bin/server.dart` (ajouter la page)

### Comment créer un composant interactif ?

```bash
ssr generate component counter
```

Puis implémenter la logique dans `lib/components/counter_component.dart`.

### Comment utiliser la base de données ?

```dart
import 'package:sqlite3/sqlite3.dart';

class DatabaseService {
  late Database _db;
  
  void init() {
    _db = sqlite3.open('data/app.db');
    _createTables();
  }
  
  void _createTables() {
    _db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL
      )
    ''');
  }
}
```

### Comment déployer en production ?

Voir le [Guide de déploiement](guides/deployment.md).

Options :
- Serveur dédié avec systemd
- Docker
- Cloud (Google Cloud Run, AWS, Heroku)

## Performance

### Comment améliorer les performances ?

1. **Code splitting** : Utiliser les imports différés
2. **Prefetching** : Précharger les données des liens visibles
3. **Cache** : Mettre en cache les réponses API
4. **Optimistic updates** : Mettre à jour l'UI avant la réponse API
5. **Lazy loading** : Charger les composants à la demande

### Pourquoi mon bundle JavaScript est-il gros ?

Causes possibles :
- Tous les composants sont dans le bundle initial
- Pas de code splitting
- Dépendances lourdes

Solutions :
- Utiliser les imports différés
- Analyser le bundle avec `dart run build_runner build --release --output=build`
- Supprimer les dépendances inutiles

### Comment activer le prefetching ?

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

## SEO

### Le SEO est-il bon avec SSR ?

Oui ! Le SSR Framework offre :
- Rendu HTML complet côté serveur
- Meta tags dynamiques
- Sitemap.xml automatique
- Robots.txt
- URLs canoniques
- Open Graph et Twitter Cards

### Comment vérifier le SEO ?

1. Utiliser [Google Lighthouse](https://developers.google.com/web/tools/lighthouse)
2. Vérifier avec [Google Search Console](https://search.google.com/search-console)
3. Tester avec [Facebook Sharing Debugger](https://developers.facebook.com/tools/debug/)

### Comment ajouter des meta tags personnalisés ?

```dart
_meta.updateMeta(
  title: 'Mon titre',
  description: 'Ma description',
  canonical: 'https://myapp.com/page',
  ogTags: {
    'title': 'Titre Open Graph',
    'description': 'Description Open Graph',
    'image': 'https://myapp.com/image.jpg',
  },
);
```

## PWA

### Comment transformer mon app en PWA ?

1. Activer PWA dans la configuration :
```dart
final config = SsrConfig(enablePwa: true);
```

2. Générer le manifest :
```dart
final manifest = ManifestGenerator.generate(
  name: 'Mon App',
  shortName: 'App',
  startUrl: '/',
  themeColor: '#2c3e50',
  backgroundColor: '#ffffff',
);
```

3. Générer le service worker :
```dart
final sw = ServiceWorkerGenerator.generate(
  cacheName: 'app-v1',
  staticAssets: ['/', '/static/main.dart.js'],
);
```

### Mon PWA ne s'installe pas, pourquoi ?

Vérifiez :
1. HTTPS activé (requis en production)
2. Manifest.json valide
3. Service worker enregistré
4. Icônes disponibles (192x192 et 512x512 minimum)

Utilisez Chrome DevTools > Application pour diagnostiquer.

## Dépannage

### Erreur : `libsqlite3.so not found`

Installer libsqlite3-dev :
```bash
sudo apt-get install libsqlite3-dev  # Ubuntu/Debian
brew install sqlite                   # macOS
```

### Erreur : `Port already in use`

Utiliser un autre port :
```bash
ssr serve --port 8080
```

Ou arrêter le processus existant :
```bash
lsof -ti:3000 | xargs kill -9
```

### Erreur : `Template not found`

Vérifier :
1. Le fichier existe dans `templates/pages/`
2. Le chemin dans `SsrConfig.templatesDir` est correct
3. L'extension du fichier est `.html`

### Mon composant AngularDart ne s'affiche pas

Vérifier :
1. Le composant est dans les `directives` du composant parent
2. Le selector est correct
3. Le code a été généré avec `build_runner`

## Contribution

### Comment contribuer au projet ?

1. Fork le repository
2. Créer une branche (`git checkout -b feature/ma-feature`)
3. Commit les changements (`git commit -m 'Add ma feature'`)
4. Push vers la branche (`git push origin feature/ma-feature`)
5. Ouvrir une Pull Request

Voir [CONTRIBUTING.md](../CONTRIBUTING.md) pour plus de détails.

### Comment signaler un bug ?

Ouvrir une issue sur GitHub avec :
- Description du bug
- Étapes pour reproduire
- Comportement attendu
- Comportement actuel
- Environnement (OS, Dart version, etc.)

### Comment proposer une nouvelle fonctionnalité ?

1. Ouvrir une issue pour discuter de la fonctionnalité
2. Attendre le feedback des maintainers
3. Implémenter la fonctionnalité
4. Soumettre une Pull Request

## Ressources

- [Documentation](README.md)
- [Exemples](examples/README.md)
- [API Reference](api/README.md)
- [GitHub Repository](https://github.com/yourusername/ssr_framework)
