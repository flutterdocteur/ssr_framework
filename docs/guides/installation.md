# Guide d'installation

Ce guide couvre l'installation complète du framework SSR sur différents systèmes d'exploitation.

## Prérequis système

### Windows
- Windows 10 ou supérieur
- Dart SDK 3.12.2+ ([télécharger](https://dart.dev/get-dart))
- Git ([télécharger](https://git-scm.com/))

### macOS
- macOS 10.15 ou supérieur
- Dart SDK 3.12.2+ ([télécharger](https://dart.dev/get-dart))
- Xcode Command Line Tools : `xcode-select --install`

### Linux (Debian/Ubuntu)
```bash
# Installer Dart
sudo apt-get update
sudo apt-get install apt-transport-https
wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/dart.gpg
echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | sudo tee /etc/apt/sources.list.d/dart_stable.list
sudo apt-get update
sudo apt-get install dart

# Ajouter au PATH
export PATH="$PATH:/usr/lib/dart/bin"
```

### Linux (Fedora)
```bash
sudo dnf install dart
```

## Installation du framework

### Méthode 1 : Installation globale (recommandée)

```bash
# Cloner le repository
git clone https://github.com/flutterdocteur/ssr_framework.git
cd ssr_framework

# Installer les dépendances
./install.sh

# Activer le CLI globalement
cd packages/ssr_cli
dart pub global activate --source path .
```

### Méthode 2 : Installation locale

```bash
# Cloner le repository
git clone https://github.com/flutterdocteur/ssr_framework.git
cd ssr_framework

# Installer les dépendances pour chaque package
cd packages/ssr_core && dart pub get && cd ../..
cd packages/ssr_server && dart pub get && cd ../..
cd packages/ssr_client && dart pub get && cd ../..
cd packages/ssr_cli && dart pub get && cd ../..
```

## Vérification de l'installation

```bash
# Vérifier la version de Dart
dart --version

# Vérifier le CLI SSR
ssr --help
```

Vous devriez voir :
```
SSR Framework CLI

Usage: ssr <command> [arguments]

Available commands:
  create    Create a new SSR project
  generate  Generate pages, components, or services
  build     Build the project for production
  serve     Start the development server
```

## Configuration de l'environnement

### Variables d'environnement

Créez un fichier `.env` à la racine de votre projet :

```bash
# Port du serveur
PORT=3000

# URL de base
BASE_URL=http://localhost:3000

# Mode développement
DEV_MODE=true

# Base de données
DATABASE_PATH=data/app.db
```

### Configuration IDE

#### VS Code

Installez les extensions recommandées :
- Dart (Dart-Code.dart-code)
- Angular Language Service
- Jinja Template

Créez `.vscode/settings.json` :

```json
{
  "dart.lineLength": 80,
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true
  },
  "files.associations": {
    "*.html": "jinja"
  }
}
```

#### IntelliJ/Android Studio

1. Installez le plugin Dart
2. Configurez le SDK Dart : `File > Settings > Languages & Frameworks > Dart`
3. Activez le formatage automatique : `Settings > Editor > Code Style > Dart`

## Dépannage

### Erreur : "dart: command not found"

**Solution** : Ajoutez Dart au PATH

```bash
# Linux/macOS
export PATH="$PATH:/usr/lib/dart/bin"

# Windows
# Ajoutez C:\dart-sdk\bin au PATH système
```

### Erreur : "ssr: command not found"

**Solution** : Activez le CLI globalement

```bash
cd packages/ssr_cli
dart pub global activate --source path .
```

### Erreur : "Package not found"

**Solution** : Installez les dépendances

```bash
dart pub get
```

### Erreur : "Port already in use"

**Solution** : Changez le port

```bash
ssr serve --port 8080
```

Ou arrêtez le processus existant :

```bash
# Linux/macOS
lsof -ti:3000 | xargs kill -9

# Windows
netstat -ano | findstr :3000
taskkill /PID <PID> /F
```

## Mise à jour

```bash
# Mettre à jour le framework
cd ssr_framework
git pull

# Réinstaller les dépendances
./install.sh

# Mettre à jour le CLI
cd packages/ssr_cli
dart pub global activate --source path .
```

## Désinstallation

```bash
# Désactiver le CLI
dart pub global deactivate ssr_cli

# Supprimer le framework
rm -rf ssr_framework
```

## Prochaines étapes

- [Guide de démarrage rapide](quickstart.md)
- [Guide de déploiement](deployment.md)
- [Configuration avancée](configuration.md)
