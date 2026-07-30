#!/bin/bash

# Script d'installation pour SSR Framework

set -e

echo "🚀 Installation de SSR Framework"
echo ""

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Installer les dépendances pour chaque package
packages=(
  "packages/ssr_core"
  "packages/ssr_server"
  "packages/ssr_client"
  "packages/ssr_router"
  "packages/ssr_hydration"
  "packages/ssr_seo"
  "packages/ssr_pwa"
  "packages/ssr_example"
)

for package in "${packages[@]}"; do
  echo -e "${BLUE}📦 Installation de $package...${NC}"
  cd "$package"
  dart pub get
  cd ../..
done

echo ""
echo -e "${GREEN}✅ Installation terminée!${NC}"
echo ""
echo "Pour démarrer l'exemple:"
echo "  cd packages/ssr_example"
echo "  dart run build_runner build --release"
echo "  dart run bin/server.dart"
