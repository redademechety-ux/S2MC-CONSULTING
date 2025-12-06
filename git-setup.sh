#!/bin/bash

# Script pour configurer et pousser vers GitHub
# Repository: https://github.com/redademechety-ux/S2MC-CONSULTING

echo "================================================"
echo "  Configuration Git pour S2MC Consulting"
echo "================================================"
echo ""

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Vérifier si Git est installé
if ! command -v git &> /dev/null; then
    print_error "Git n'est pas installé"
    echo "Pour installer Git:"
    echo "  sudo apt-get install git"
    exit 1
fi

print_success "Git est installé ($(git --version))"

# Aller dans le dossier du projet
cd /app

# Configuration de Git
print_info "Configuration de Git..."
read -p "Votre nom (pour les commits): " GIT_NAME
read -p "Votre email: " GIT_EMAIL

git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"

print_success "Git configuré avec:"
echo "  Nom: $GIT_NAME"
echo "  Email: $GIT_EMAIL"
echo ""

# Initialiser le dépôt si nécessaire
if [ ! -d ".git" ]; then
    print_info "Initialisation du dépôt Git..."
    git init
    print_success "Dépôt Git initialisé"
else
    print_success "Dépôt Git déjà initialisé"
fi

# Ajouter tous les fichiers
print_info "Ajout des fichiers..."
git add .

# Status
echo ""
print_info "Fichiers à commiter:"
git status --short
echo ""

# Premier commit
read -p "Message du commit [Initial commit: S2MC Consulting website]: " COMMIT_MSG
COMMIT_MSG=${COMMIT_MSG:-"Initial commit: S2MC Consulting website with Nginx deployment scripts"}

git commit -m "$COMMIT_MSG"
print_success "Commit créé"

# Ajouter le remote GitHub
GITHUB_REPO="https://github.com/redademechety-ux/S2MC-CONSULTING.git"

if git remote | grep -q "origin"; then
    print_info "Remote 'origin' existe déjà"
    git remote set-url origin $GITHUB_REPO
    print_success "Remote mis à jour"
else
    git remote add origin $GITHUB_REPO
    print_success "Remote ajouté: $GITHUB_REPO"
fi

# Créer/passer à la branche main
git branch -M main
print_success "Branche 'main' créée"

echo ""
print_info "Prêt à pousser vers GitHub!"
echo ""
echo "Repository: $GITHUB_REPO"
echo ""

read -p "Pousser maintenant vers GitHub ? (o/n): " PUSH_NOW

if [ "$PUSH_NOW" = "o" ] || [ "$PUSH_NOW" = "O" ]; then
    echo ""
    print_info "Push vers GitHub..."
    echo ""
    echo "Si demandé, utilisez:"
    echo "  - Username: redademechety-ux"
    echo "  - Password: votre token GitHub personnel"
    echo ""
    print_info "Pour créer un token: GitHub → Settings → Developer settings → Personal access tokens"
    echo ""
    
    git push -u origin main
    
    if [ $? -eq 0 ]; then
        echo ""
        print_success "Code poussé vers GitHub avec succès!"
        echo ""
        print_info "Voir votre code sur:"
        echo "  https://github.com/redademechety-ux/S2MC-CONSULTING"
    else
        echo ""
        print_error "Erreur lors du push"
        echo ""
        print_info "Solutions possibles:"
        echo "  1. Vérifiez vos identifiants GitHub"
        echo "  2. Créez un Personal Access Token sur GitHub"
        echo "  3. Utilisez SSH au lieu de HTTPS"
        echo ""
        print_info "Pour réessayer manuellement:"
        echo "  git push -u origin main"
    fi
else
    echo ""
    print_info "Push annulé"
    echo ""
    print_info "Pour pousser plus tard, exécutez:"
    echo "  cd /app"
    echo "  git push -u origin main"
fi

echo ""
print_success "Configuration terminée!"
echo ""
