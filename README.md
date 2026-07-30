# SSR Framework

Un framework Dart moderne inspiré de Next.js pour créer des applications web avec Server-Side Rendering (SSR) et hydratation automatique.

## Caractéristiques

- **SSR natif** : Rendu côté serveur avec Alfred et Jinja
- **Hydratation automatique** : Transfert d'état serveur → client
- **Routing文件系统** : Routes automatiques basées sur la structure de fichiers
- **Code splitting** : Chargement à la demande des composants
- **SEO avancé** : Meta tags dynamiques, sitemap, robots.txt
- **PWA support** : Service worker, manifest, offline
- **State management** : Redux-like avec streams
- **Optimistic updates** : UI réactive avant la réponse API

## Architecture

```
ssr_framework/
├── packages/
│   ├── ssr_core/          # Interfaces et types fondamentaux
│   ├── ssr_server/        # Serveur HTTP + SSR
│   ├── ssr_client/        # Hydratation + routing client
│   ├── ssr_router/        # Routing文件系统
│   ├── ssr_hydration/     # Hydratation automatique
│   ├── ssr_seo/           # SEO utilities
│   ├── ssr_pwa/           # PWA utilities
│   ├── ssr_cli/           # Command-line interface
│   └── ssr_example/       # Application d'exemple
├── docs/                  # Documentation complète
├── LICENSE
├── CHANGELOG.md
├── CONTRIBUTING.md
└── README.md
```

## Installation

```bash
# Cloner le repository
git clone https://github.com/flutterdocteur/ssr_framework.git
cd ssr_framework

# Installer les dépendances
cd packages/ssr_example
dart pub get

# Build le client
dart run build_runner build --release

# Démarrer le serveur
dart run bin/server.dart
```

## Utilisation rapide

### 1. Créer une page

```dart
// lib/pages/home_page.dart
import 'package:ssr_core/ssr_core.dart';
import 'package:ssr_server/ssr_server.dart';

class HomePage extends SsrPageBase {
  HomePage() : super(
    path: '/',
    title: 'Accueil',
    description: 'Page d\'accueil',
  );

  @override
  Future<String> render(Map<String, dynamic> data) async {
    final templateEngine = TemplateEngine('templates');
    await templateEngine.init();
    return templateEngine.render('pages/home.html', data);
  }

  @override
  Future<Map<String, dynamic>> getInitialData() async {
    return {
      'items': [
        {'id': 1, 'name': 'Item 1'},
        {'id': 2, 'name': 'Item 2'},
      ],
    };
  }
}
```

### 2. Configurer le serveur

```dart
// bin/server.dart
import 'package:ssr_core/ssr_core.dart';
import 'package:ssr_server/ssr_server.dart';
import 'pages/home_page.dart';

void main() async {
  final config = SsrConfig(
    name: 'Mon App',
    baseUrl: 'http://localhost:3000',
    port: 3000,
    devMode: true,
  );

  final pages = [
    HomePage(),
  ];

  final server = SsrServer(config: config, pages: pages);
  await server.start();
}
```

### 3. Créer le template

```html
<!-- templates/pages/home.html -->
{% extends "base.html" %}

{% block title %}{{ title }}{% endblock %}

{% block content %}
<h1>Bienvenue</h1>
<ul>
  {% for item in items %}
  <li>{{ item.name }}</li>
  {% endfor %}
</ul>
{% endblock %}
```

## Packages

### ssr_core
Interfaces et types fondamentaux :
- `SsrApp` : Interface d'application
- `SsrPage` : Interface de page
- `SsrConfig` : Configuration
- `SsrRouter` : Interface de routing
- `SsrState` : Interface de state management

### ssr_server
Serveur HTTP avec SSR :
- `SsrServer` : Serveur principal
- `TemplateEngine` : Moteur de templates Jinja
- `StaticHandler` : Gestion des fichiers statiques
- `SeoHandler` : Génération sitemap/robots

### ssr_client
Client-side hydration :
- `HydrationService` : Hydratation des données
- `NavigationService` : Routing client
- `ApiService` : Client HTTP
- `MetaService` : Meta tags dynamiques

### ssr_router
Routing文件系统 :
- `FileRouter` : Découverte automatique des routes
- `RouteRegistry` : Registre des routes

### ssr_hydration
Hydratation automatique :
- `HydrationEngine` : Sérialisation/désérialisation
- `DataTransfer` : Transfert de données

### ssr_seo
SEO utilities :
- `SeoGenerator` : Génération sitemap/robots
- `MetaTags` : Génération de meta tags

### ssr_pwa
PWA utilities :
- `ManifestGenerator` : Génération manifest.json
- `ServiceWorkerGenerator` : Génération service worker

### ssr_cli
Command-line interface :
- `ssr create` : Créer un projet
- `ssr generate` : Générer des pages/composants/services
- `ssr build` : Build production
- `ssr serve` : Démarrer le serveur

## Documentation

- 📖 [Documentation complète](docs/README.md)
- 🚀 [Guide de démarrage rapide](docs/guides/quickstart.md)
- 📦 [Installation](docs/guides/installation.md)
- 🌐 [Déploiement](docs/guides/deployment.md)
- ⚙️ [Configuration avancée](docs/guides/configuration.md)
- ✨ [Best practices](docs/guides/best-practices.md)
- 🔧 [Troubleshooting](docs/guides/troubleshooting.md)
- ❓ [FAQ](docs/faq.md)
- 📚 [API Reference](docs/api/README.md)
- 💡 [Exemples](docs/examples/README.md)

## Roadmap

- [x] Phase 1 : Prototype fonctionnel
- [x] Phase 2 : SEO & PWA
- [x] Phase 3 : Base de données SQLite
- [x] Phase 4 : Tests d'intégration
- [x] Phase 5 : Restructuration en packages
- [x] Phase 6 : Documentation & exemples
- [ ] Phase 7 : Publication sur pub.dev

## Contribuer

Les contributions sont les bienvenues ! Voir [CONTRIBUTING.md](CONTRIBUTING.md) pour plus de détails.

## Licence

MIT
