# Guide de démarrage rapide

Ce guide vous aidera à créer votre première application SSR avec le framework en moins de 5 minutes.

## Prérequis

- Dart SDK 3.12.2 ou supérieur
- Git (optionnel)

## Installation

### 1. Créer un nouveau projet

```bash
# Activer le CLI globalement
cd packages/ssr_cli
dart pub global activate --source path .

# Créer un nouveau projet
ssr create my-first-app
cd my-first-app
```

### 2. Installer les dépendances

```bash
dart pub get
```

### 3. Lancer le serveur de développement

```bash
ssr serve
```

Votre application est maintenant accessible sur [http://localhost:3000](http://localhost:3000).

## Structure du projet

```
my-first-app/
├── bin/
│   └── server.dart              # Point d'entrée serveur
├── lib/
│   ├── pages/                   # Pages SSR
│   │   ├── home_page.dart
│   │   └── about_page.dart
│   ├── components/              # Composants AngularDart
│   └── services/                # Services
├── web/
│   ├── index.html               # HTML de base
│   └── main.dart                # Point d'entrée client
├── public/                      # Fichiers statiques
├── templates/                   # Templates Jinja
│   ├── base.html
│   └── pages/
│       ├── home.html
│       └── about.html
└── test/                        # Tests
```

## Créer votre première page

### 1. Générer une page

```bash
ssr generate page contact
```

Cela crée :
- `lib/pages/contact_page.dart` - Classe de la page
- `templates/pages/contact.html` - Template HTML

### 2. Modifier la page

Ouvrez `lib/pages/contact_page.dart` :

```dart
import 'package:ssr_core/ssr_core.dart';
import 'package:ssr_server/ssr_server.dart';

class ContactPage extends SsrPageBase {
  ContactPage() : super(
    path: '/contact',
    title: 'Contact',
    description: 'Page de contact',
  );

  @override
  Future<String> render(Map<String, dynamic> data) async {
    final templateEngine = TemplateEngine('templates');
    await templateEngine.init();
    return templateEngine.render('pages/contact.html', data);
  }

  @override
  Future<Map<String, dynamic>> getInitialData() async {
    return {
      'email': 'contact@example.com',
      'phone': '+33 1 23 45 67 89',
    };
  }
}
```

### 3. Modifier le template

Ouvrez `templates/pages/contact.html` :

```html
{% extends "base.html" %}

{% block title %}Contact{% endblock %}
{% block description %}Contactez-nous{% endblock %}

{% block content %}
<h1>Contact</h1>
<p>Email: {{ email }}</p>
<p>Téléphone: {{ phone }}</p>
{% endblock %}
```

### 4. Enregistrer la page

Ouvrez `bin/server.dart` et ajoutez la page :

```dart
import 'pages/contact_page.dart';

final pages = [
  HomePage(),
  AboutPage(),
  ContactPage(),  // <-- Ajouter cette ligne
];
```

### 5. Redémarrer le serveur

```bash
# Arrêter le serveur (Ctrl+C)
ssr serve
```

Visitez [http://localhost:3000/contact](http://localhost:3000/contact).

## Créer un composant interactif

### 1. Générer un composant

```bash
ssr generate component counter
```

### 2. Implémenter le composant

Ouvrez `lib/components/counter_component.dart` :

```dart
import 'package:angulardart/angulardart.dart';

@Component(
  selector: 'counter',
  template: '''
    <div class="counter">
      <h2>Compteur: {{ count }}</h2>
      <button (click)="increment()">+</button>
      <button (click)="decrement()">-</button>
    </div>
  ''',
  styles: [
    '''
    .counter { padding: 1rem; }
    button { margin: 0.5rem; padding: 0.5rem 1rem; }
    '''
  ],
)
class CounterComponent {
  int count = 0;

  void increment() => count++;
  void decrement() => count--;
}
```

### 3. Utiliser le composant

Dans votre template HTML :

```html
{% extends "base.html" %}

{% block content %}
<h1>Ma page</h1>
<counter></counter>
{% endblock %}
```

## Build pour la production

```bash
ssr build --release
```

Cela génère les fichiers optimisés dans `public/`.

## Déploiement

### Option 1 : Serveur dédié

```bash
# Build
ssr build --release

# Démarrer le serveur
dart run bin/server.dart
```

### Option 2 : Docker

Créez un `Dockerfile` :

```dockerfile
FROM dart:stable AS build
WORKDIR /app
COPY . .
RUN dart pub get
RUN dart run build_runner build --release

FROM dart:stable
WORKDIR /app
COPY --from=build /app .
EXPOSE 3000
CMD ["dart", "run", "bin/server.dart"]
```

## Prochaines étapes

- [Guide d'installation détaillé](installation.md)
- [Guide de déploiement](deployment.md)
- [API Reference](../api/README.md)
- [Exemples](../examples/README.md)

## Ressources

- [Documentation complète](README.md)
- [Exemples d'applications](../examples/)
- [FAQ](faq.md)
