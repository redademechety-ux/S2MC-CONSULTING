#!/bin/bash

# Script de mise à jour S2MC Consulting Website

set -e

echo "================================="
echo "S2MC Consulting - Mise à jour"
echo "================================="
echo ""

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

# Vérifier root
if [ "$EUID" -ne 0 ]; then 
    print_error "Ce script doit être exécuté en tant que root (sudo)"
    exit 1
fi

# Demander le chemin du site
read -p "Chemin du site [/var/www/s2mc-consulting]: " SITE_PATH
SITE_PATH=${SITE_PATH:-/var/www/s2mc-consulting}

if [ ! -d "$SITE_PATH" ]; then
    print_error "Le répertoire $SITE_PATH n'existe pas"
    exit 1
fi

print_info "Chemin du site: $SITE_PATH"

# Demander confirmation
read -p "Continuer la mise à jour ? (o/n): " confirm
if [ "$confirm" != "o" ] && [ "$confirm" != "O" ]; then
    print_error "Mise à jour annulée"
    exit 0
fi

echo ""

# Créer une sauvegarde
print_info "Création d'une sauvegarde..."
BACKUP_DIR="${SITE_PATH}.backup.$(date +%Y%m%d_%H%M%S)"
cp -r $SITE_PATH $BACKUP_DIR
print_success "Sauvegarde créée: $BACKUP_DIR"

# Copier les nouveaux fichiers
print_info "Copie des nouveaux fichiers..."
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

if [ -d "$PROJECT_DIR/frontend" ]; then
    # Si on a le projet complet, builder
    print_info "Build de l'application..."
    cd $PROJECT_DIR/frontend
    
    if [ -d "node_modules" ]; then
        yarn build
    else
        yarn install
        yarn build
    fi
    
    # Supprimer les anciens fichiers
    rm -rf $SITE_PATH/*
    
    # Copier les nouveaux
    cp -r build/* $SITE_PATH/
    
    print_success "Nouveaux fichiers déployés"
else
    print_error "Répertoire frontend introuvable"
    print_info "Restauration de la sauvegarde..."
    rm -rf $SITE_PATH
    mv $BACKUP_DIR $SITE_PATH
    exit 1
fi

# Corriger les permissions
print_info "Correction des permissions..."
chown -R www-data:www-data $SITE_PATH
chmod -R 755 $SITE_PATH
print_success "Permissions corrigées"

# Redémarrer le serveur web
if systemctl is-active --quiet apache2; then
    print_info "Redémarrage d'Apache..."
    systemctl restart apache2
    print_success "Apache redémarré"
elif systemctl is-active --quiet nginx; then
    print_info "Redémarrage de Nginx..."
    systemctl restart nginx
    print_success "Nginx redémarré"
fi

echo ""
print_success "Mise à jour terminée !"
echo ""
print_info "Sauvegarde disponible dans: $BACKUP_DIR"
print_info "Pour restaurer en cas de problème:"
echo "  sudo rm -rf $SITE_PATH"
echo "  sudo mv $BACKUP_DIR $SITE_PATH"
echo ""
