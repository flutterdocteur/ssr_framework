# SSR CLI

Outils en ligne de commande pour SSR Framework.

## Installation

```bash
# Depuis le répertoire du framework
cd packages/ssr_cli
dart pub get
dart pub global activate --source path .
```

## Commandes

### `ssr create`

Créer un nouveau projet SSR.

```bash
ssr create my-app
```

Options :
- `--template <name>` : Template à utiliser (basic, full)
- `--force` : Forcer la création même si le dossier existe

### `ssr generate`

Générer des pages, composants ou services.

```bash
# Générer une page
ssr generate page profile

# Générer un composant
ssr generate component user-card

# Générer un service
ssr generate service auth
```

### `ssr build`

Construire le projet pour la production.

```bash
ssr build
```

Options :
- `--release` : Build en mode release (optimisé)

### `ssr serve`

Démarrer le serveur de développement.

```bash
ssr serve
```

Options :
- `--port <port>` : Port du serveur (défaut: 3000)

## Exemples

### Créer un nouveau projet

```bash
ssr create my-blog
cd my-blog
dart pub get
ssr build
ssr serve
```

### Ajouter une page

```bash
ssr generate page contact
# Modifier lib/pages/contact_page.dart
# Modifier templates/pages/contact.html
# Ajouter la page dans bin/server.dart
```

### Ajouter un composant

```bash
ssr generate component header
# Modifier lib/components/header_component.dart
# Utiliser dans vos templates
```

## Structure d'un projet

```
my-app/
├── bin/
│   └── server.dart          # Point d'entrée serveur
├── lib/
│   ├── pages/               # Pages SSR
│   ├── components/          # Composants AngularDart
│   └── services/            # Services
├── web/
│   ├── index.html           # HTML de base
│   └── main.dart            # Point d'entrée client
├── public/                  # Fichiers statiques
├── templates/               # Templates Jinja
│   ├── base.html
│   └── pages/
└── test/                    # Tests
```

## Licence

MIT
