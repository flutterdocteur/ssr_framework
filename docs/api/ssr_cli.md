# API Reference - ssr_cli

Outils en ligne de commande pour le framework.

## Commandes

### `ssr create <project-name>`

Crée un nouveau projet SSR.

```bash
ssr create my-app [options]
```

**Options :**

| Option | Abbr | Défaut | Description |
|--------|------|--------|-------------|
| `--template` | `-t` | `basic` | Template du projet (`basic`, `full`) |
| `--force` | `-f` | `false` | Forcer la création même si le dossier existe |

**Exemples :**

```bash
# Créer un projet basique
ssr create my-app

# Créer avec le template complet
ssr create my-app --template full

# Forcer la création
ssr create my-app --force
```

**Structure générée :**

```
my-app/
├── bin/
│   └── server.dart
├── lib/
│   ├── pages/
│   │   ├── home_page.dart
│   │   └── about_page.dart
│   ├── components/
│   └── services/
├── web/
│   ├── index.html
│   └── main.dart
├── public/
├── templates/
│   ├── base.html
│   └── pages/
│       ├── home.html
│       └── about.html
├── test/
├── pubspec.yaml
├── README.md
└── .gitignore
```

### `ssr generate <type> <name>`

Génère du code pour pages, composants ou services.

```bash
ssr generate <type> <name>
```

**Types disponibles :**

| Type | Description | Fichiers générés |
|------|-------------|------------------|
| `page` | Page SSR | `lib/pages/<name>_page.dart` + `templates/pages/<name>.html` |
| `component` | Composant AngularDart | `lib/components/<name>_component.dart` |
| `service` | Service | `lib/services/<name>_service.dart` |

**Exemples :**

```bash
# Générer une page
ssr generate page contact
# → lib/pages/contact_page.dart
# → templates/pages/contact.html

# Générer un composant
ssr generate component user-card
# → lib/components/user_card_component.dart

# Générer un service
ssr generate service auth
# → lib/services/auth_service.dart
```

**Conventions de nommage :**

- Noms en kebab-case : `user-card`, `auth-service`
- Convertis en PascalCase pour les classes : `UserCardComponent`, `AuthService`
- Convertis en snake_case pour les fichiers : `user_card_component.dart`

### `ssr build`

Construit le projet pour la production.

```bash
ssr build [options]
```

**Options :**

| Option | Abbr | Description |
|--------|------|-------------|
| `--release` | `-r` | Build en mode release (optimisé) |

**Exemples :**

```bash
# Build en mode développement
ssr build

# Build en mode release
ssr build --release
```

**Processus :**

1. Exécute `dart run build_runner build`
2. Copie les fichiers générés vers `public/`
3. Génère les fichiers optimisés (`.js`, `.part.js`)

### `ssr serve`

Démarre le serveur de développement.

```bash
ssr serve [options]
```

**Options :**

| Option | Abbr | Défaut | Description |
|--------|------|--------|-------------|
| `--port` | `-p` | `3000` | Port du serveur |

**Exemples :**

```bash
# Démarrer sur le port par défaut
ssr serve

# Démarrer sur un port spécifique
ssr serve --port 8080
```

**Fonctionnalités :**

- Rechargement automatique (avec `build_runner watch`)
- Logs des requêtes
- Gestion des erreurs

## Utilitaires

### `FileUtils`

Utilitaires pour la manipulation de fichiers.

```dart
class FileUtils {
  static Future<void> ensureDirectory(String dirPath);
  static Future<void> writeFile(String filePath, String content);
  static Future<void> copyFile(String source, String destination);
  static Future<void> deleteDirectory(String dirPath);
  static Future<List<String>> listFiles(String dirPath, {String? extension});
  static Future<bool> fileExists(String filePath);
  static Future<String> readFile(String filePath);
}
```

**Exemple :**

```dart
await FileUtils.ensureDirectory('lib/pages');
await FileUtils.writeFile('lib/pages/test.dart', 'content');
final files = await FileUtils.listFiles('lib', extension: '.dart');
```

### `TemplateUtils`

Utilitaires pour la manipulation de chaînes.

```dart
class TemplateUtils {
  static String toPascalCase(String s);
  static String toCamelCase(String s);
  static String toSnakeCase(String s);
  static String toKebabCase(String s);
  static String capitalize(String s);
  static String fileToRoute(String filePath);
  static String generateId();
  static String formatDate(DateTime date);
  static String formatDateTime(DateTime date);
}
```

**Exemple :**

```dart
TemplateUtils.toPascalCase('user-card');  // 'UserCard'
TemplateUtils.toSnakeCase('UserCard');    // 'user_card'
TemplateUtils.toKebabCase('UserCard');    // 'user-card'
TemplateUtils.fileToRoute('lib/pages/profile/[id]_page.dart');  // '/profile/:id'
```

## Configuration

### Activation globale

```bash
cd packages/ssr_cli
dart pub global activate --source path .
```

### Désactivation

```bash
dart pub global deactivate ssr_cli
```

## Workflows typiques

### Créer un nouveau projet

```bash
ssr create my-app
cd my-app
dart pub get
ssr serve
```

### Ajouter une page

```bash
ssr generate page contact
# Modifier lib/pages/contact_page.dart
# Modifier templates/pages/contact.html
# Ajouter dans bin/server.dart
ssr serve
```

### Build pour production

```bash
ssr build --release
dart run bin/server.dart
```

### Développement avec hot reload

```bash
# Terminal 1
dart run build_runner watch

# Terminal 2
ssr serve
```

## Codes de sortie

| Code | Signification |
|------|---------------|
| `0` | Succès |
| `1` | Erreur générale |
| `2` | Arguments invalides |
| `3` | Fichier non trouvé |

## Variables d'environnement

| Variable | Description |
|----------|-------------|
| `PORT` | Port du serveur (override `--port`) |
| `BASE_URL` | URL de base de l'application |
| `DEV_MODE` | Mode développement (`true`/`false`) |
