#!/bin/bash

set -e

echo "🚀 Publication de SSR Framework sur pub.dev"
echo ""

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Vérifier que nous sommes dans le bon répertoire
if [ ! -f "packages/ssr_core/pubspec.yaml" ]; then
  echo -e "${YELLOW}⚠️  Veuillez exécuter ce script depuis le répertoire racine de ssr_framework${NC}"
  exit 1
fi

# Vérifier la connexion
echo -e "${BLUE}🔐 Vérification de la connexion à pub.dev...${NC}"
dart pub login

# Publier ssr_core en premier
echo ""
echo -e "${BLUE}📦 Étape 1/8 : Publication de ssr_core...${NC}"
cd packages/ssr_core
dart pub publish --force
cd ../..

# Attendre que ssr_core soit disponible
echo ""
echo -e "${YELLOW}⏳ Attente de la disponibilité de ssr_core sur pub.dev (60 secondes)...${NC}"
sleep 60

# Publier ssr_cli (pas de dépendance interne)
echo ""
echo -e "${BLUE}📦 Étape 2/8 : Publication de ssr_cli...${NC}"
cd packages/ssr_cli
dart pub publish --force
cd ../..

# Publier les packages qui dépendent de ssr_core
for i in {3..8}; do
  case $i in
    3) pkg="ssr_hydration" ;;
    4) pkg="ssr_seo" ;;
    5) pkg="ssr_pwa" ;;
    6) pkg="ssr_router" ;;
    7) pkg="ssr_server" ;;
    8) pkg="ssr_client" ;;
  esac
  
  echo ""
  echo -e "${BLUE}📦 Étape $i/8 : Publication de $pkg...${NC}"
  cd packages/$pkg
  dart pub publish --force
  cd ../..
  sleep 10
done

echo ""
echo -e "${GREEN}✅ Tous les packages ont été publiés avec succès !${NC}"
echo ""
echo -e "${GREEN}🔗 Liens vers les packages :${NC}"
echo "  - https://pub.dev/packages/ssr_core"
echo "  - https://pub.dev/packages/ssr_server"
echo "  - https://pub.dev/packages/ssr_client"
echo "  - https://pub.dev/packages/ssr_router"
echo "  - https://pub.dev/packages/ssr_hydration"
echo "  - https://pub.dev/packages/ssr_seo"
echo "  - https://pub.dev/packages/ssr_pwa"
echo "  - https://pub.dev/packages/ssr_cli"
echo ""
echo -e "${GREEN}📢 N'oubliez pas d'annoncer la publication !${NC}"
