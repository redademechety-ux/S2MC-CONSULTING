#!/bin/bash

# Script de build local S2MC Consulting Website

set -e

echo "================================="
echo "S2MC Consulting - Build Local"
echo "================================="
echo ""

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
FRONTEND_DIR="$PROJECT_DIR/frontend"

if [ ! -d "$FRONTEND_DIR" ]; then
    echo "Erreur: Répertoire frontend introuvable"
    exit 1
fi

cd $FRONTEND_DIR

# Installation des dépendances
if [ ! -d "node_modules" ]; then
    print_info "Installation des dépendances..."
    yarn install
    print_success "Dépendances installées"
else
    print_success "Dépendances déjà installées"
fi

# Build
print_info "Build de l'application..."
yarn build
print_success "Build terminé"

echo ""
print_success "Build créé avec succès !"
echo ""
print_info "Les fichiers sont disponibles dans: $FRONTEND_DIR/build"
print_info "Pour déployer, copiez le contenu de ce dossier sur votre serveur:"
echo "  scp -r build/* user@serveur:/var/www/s2mc-consulting/"
echo ""
