#!/bin/bash

# Script pour cr\u00e9er un package d\u00e9ployable S2MC Consulting Website

set -e

echo "================================="
echo "Cr\u00e9ation du package de d\u00e9ploiement"
echo "================================="
echo ""

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_success() {
    echo -e "${GREEN}\u2713 $1${NC}"
}

print_info() {
    echo -e "${YELLOW}\u2139 $1${NC}"
}

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
PACKAGE_NAME="s2mc-website-$(date +%Y%m%d_%H%M%S)"
PACKAGE_DIR="/tmp/$PACKAGE_NAME"

# Cr\u00e9er le r\u00e9pertoire du package
print_info "Cr\u00e9ation du package..."
mkdir -p $PACKAGE_DIR

# Copier les fichiers de d\u00e9ploiement
print_info "Copie des scripts de d\u00e9ploiement..."
cp -r $SCRIPT_DIR $PACKAGE_DIR/

# Copier le frontend
print_info "Copie du frontend..."
cp -r $PROJECT_DIR/frontend $PACKAGE_DIR/

# Supprimer node_modules et build s'ils existent (pour r\u00e9duire la taille)
rm -rf $PACKAGE_DIR/frontend/node_modules
rm -rf $PACKAGE_DIR/frontend/build

print_success "Fichiers copi\u00e9s"

# Cr\u00e9er l'archive
print_info "Cr\u00e9ation de l'archive..."
cd /tmp
tar -czf $PACKAGE_NAME.tar.gz $PACKAGE_NAME/

ARCHIVE_SIZE=$(du -h $PACKAGE_NAME.tar.gz | cut -f1)

print_success "Archive cr\u00e9\u00e9e: $PACKAGE_NAME.tar.gz ($ARCHIVE_SIZE)"

# Nettoyage
rm -rf $PACKAGE_DIR

echo ""
echo "================================="
print_success "Package pr\u00eat !"
echo "================================="
echo ""
print_info "Fichier: /tmp/$PACKAGE_NAME.tar.gz"
print_info "Taille: $ARCHIVE_SIZE"
echo ""
print_info "Pour transf\u00e9rer vers votre serveur:"
echo "  scp /tmp/$PACKAGE_NAME.tar.gz user@serveur:/tmp/"
echo ""
print_info "Sur le serveur, ex\u00e9cutez:"
echo "  cd /tmp"
echo "  tar -xzf $PACKAGE_NAME.tar.gz"
echo "  cd $PACKAGE_NAME/deployment"
echo "  sudo ./install.sh"
echo ""
