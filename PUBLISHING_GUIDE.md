# Guide de Publication sur pub.dev

## Prérequis

### 1. Créer un compte pub.dev

Si vous n'avez pas encore de compte :
1. Allez sur https://pub.dev
2. Connectez-vous avec votre compte Google
3. Acceptez les conditions d'utilisation

### 2. Se connecter à pub.dev depuis le terminal

```bash
dart pub login
```

Cette commande va ouvrir votre navigateur pour vous authentifier.

### 3. Vérifier que vous êtes connecté

```bash
dart pub uploader list
```

## Ordre de Publication

Les packages doivent être publiés dans l'ordre des dépendances :

1. **ssr_core** (aucune dépendance interne)
2. **ssr_hydration** (dépend de ssr_core)
3. **ssr_seo** (dépend de ssr_core)
4. **ssr_pwa** (dépend de ssr_core)
5. **ssr_router** (dépend de ssr_core)
6. **ssr_server** (dépend de ssr_core)
7. **ssr_client** (dépend de ssr_core)
8. **ssr_cli** (aucune dépendance interne)

**Note** : `ssr_example` ne doit PAS être publié car c'est un exemple.

## Commandes de Publication

### Étape 1 : Publier ssr_core

```bash
cd packages/ssr_core
dart pub publish
```

### Étape 2 : Publier les packages sans dépendances internes

```bash
cd ../ssr_cli
dart pub publish
```

### Étape 3 : Publier les packages qui dépendent de ssr_core

Attendez quelques minutes que ssr_core soit disponible sur pub.dev, puis :

```bash
cd ../ssr_hydration
dart pub publish

cd ../ssr_seo
dart pub publish

cd ../ssr_pwa
dart pub publish

cd ../ssr_router
dart pub publish

cd ../ssr_server
dart pub publish

cd ../ssr_client
dart pub publish
```

## Vérification

Après chaque publication, vérifiez que le package est disponible :

```bash
# Attendre 1-2 minutes
dart pub cache repair
dart pub global activate ssr_core
```

Ou visitez https://pub.dev/packages/ssr_core

## Script Automatisé

Pour publier tous les packages en une seule fois :

```bash
#!/bin/bash

set -e

echo "🚀 Publication de SSR Framework sur pub.dev"
echo ""

# Vérifier la connexion
echo "🔐 Vérification de la connexion..."
dart pub login

# Publier ssr_core en premier
echo ""
echo "📦 Publication de ssr_core..."
cd packages/ssr_core
dart pub publish --force
cd ../..

# Attendre que ssr_core soit disponible
echo ""
echo "⏳ Attente de la disponibilité de ssr_core (60 secondes)..."
sleep 60

# Publier ssr_cli (pas de dépendance interne)
echo ""
echo "📦 Publication de ssr_cli..."
cd packages/ssr_cli
dart pub publish --force
cd ../..

# Publier les autres packages
for pkg in ssr_hydration ssr_seo ssr_pwa ssr_router ssr_server ssr_client; do
  echo ""
  echo "📦 Publication de $pkg..."
  cd packages/$pkg
  dart pub publish --force
  cd ../..
  sleep 10
done

echo ""
echo "✅ Tous les packages ont été publiés !"
echo ""
echo "🔗 Liens vers les packages :"
echo "  - https://pub.dev/packages/ssr_core"
echo "  - https://pub.dev/packages/ssr_server"
echo "  - https://pub.dev/packages/ssr_client"
echo "  - https://pub.dev/packages/ssr_router"
echo "  - https://pub.dev/packages/ssr_hydration"
echo "  - https://pub.dev/packages/ssr_seo"
echo "  - https://pub.dev/packages/ssr_pwa"
echo "  - https://pub.dev/packages/ssr_cli"
```

Sauvegardez ce script dans `publish.sh` et exécutez-le :

```bash
chmod +x publish.sh
./publish.sh
```

## Résolution de Problèmes

### Erreur : "You are not authorized to publish to this package"

Vous devez être ajouté comme uploader du package. Si c'est la première publication, vous êtes automatiquement l'uploader.

### Erreur : "Package version already exists"

Changez le numéro de version dans `pubspec.yaml` :
- Patch : `0.1.0` → `0.1.1`
- Minor : `0.1.0` → `0.2.0`
- Major : `0.1.0` → `1.0.0`

### Erreur : "Package validation failed"

Corrigez les erreurs indiquées par `dart pub publish --dry-run` et réessayez.

### Erreur : "Dependency not found"

Attendez que la dépendance soit disponible sur pub.dev (peut prendre 1-2 minutes après la publication).

## Après la Publication

### 1. Vérifier les pages des packages

Visitez chaque page de package sur pub.dev pour vérifier que tout est correct.

### 2. Mettre à jour le README principal

Ajoutez les badges pub.dev dans le README principal :

```markdown
[![pub package](https://img.shields.io/pub/v/ssr_core.svg)](https://pub.dev/packages/ssr_core)
[![pub package](https://img.shields.io/pub/v/ssr_server.svg)](https://pub.dev/packages/ssr_server)
[![pub package](https://img.shields.io/pub/v/ssr_client.svg)](https://pub.dev/packages/ssr_client)
```

### 3. Annoncer la publication

- Twitter/X
- Reddit (r/dartlang, r/FlutterDev)
- Discord Dart/Flutter
- Blog personnel
- Medium/Dev.to

### 4. Surveiller les issues

Surveillez les issues sur GitHub pour répondre rapidement aux questions et bugs signalés.

## Mises à Jour Futures

Pour publier une mise à jour :

1. Incrémentez la version dans `pubspec.yaml`
2. Mettez à jour `CHANGELOG.md`
3. Publiez avec `dart pub publish`

```bash
# Exemple pour une mise à jour patch
cd packages/ssr_core
# Modifier version dans pubspec.yaml : 0.1.0 → 0.1.1
# Ajouter entrée dans CHANGELOG.md
dart pub publish
```

## Ressources

- [Documentation officielle pub.dev](https://dart.dev/tools/pub/publishing)
- [Guide de publication](https://dart.dev/tools/pub/publishing#important-files)
- [Politique de pub.dev](https://pub.dev/policy)
