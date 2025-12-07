#!/bin/bash

# Script d'installation automatique S2MC Consulting Website
# Configuration optimisée pour NGINX

set -e

echo "================================="
echo "S2MC Consulting - Installation"
echo "Configuration NGINX"
echo "================================="
echo ""

# Couleurs pour les messages
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

# Vérifier si le script est exécuté en tant que root
if [ "$EUID" -ne 0 ]; then 
    print_error "Ce script doit être exécuté en tant que root (sudo)"
    exit 1
fi

print_success "Script lancé en tant que root"

# Configuration par défaut
DEFAULT_DOMAIN="s2mc-consulting.com"
DEFAULT_PATH="/var/www/s2mc-consulting"

# Demander le nom de domaine
read -p "Entrez votre nom de domaine [$DEFAULT_DOMAIN]: " DOMAIN_NAME
DOMAIN_NAME=${DOMAIN_NAME:-$DEFAULT_DOMAIN}

# Demander le chemin d'installation
read -p "Chemin d'installation [$DEFAULT_PATH]: " INSTALL_PATH
INSTALL_PATH=${INSTALL_PATH:-$DEFAULT_PATH}

# Demander l'email pour Let's Encrypt (optionnel)
read -p "Email pour SSL/Let's Encrypt (optionnel, Entrée pour ignorer): " SSL_EMAIL

echo ""
print_info "Configuration:"
echo "  - Domaine: $DOMAIN_NAME"
echo "  - Chemin: $INSTALL_PATH"
echo "  - Serveur: Nginx"
if [ ! -z "$SSL_EMAIL" ]; then
    echo "  - SSL: Oui (Let's Encrypt)"
else
    echo "  - SSL: Non (peut être ajouté plus tard)"
fi
echo ""
read -p "Continuer avec cette configuration ? (o/n): " confirm

if [ "$confirm" != "o" ] && [ "$confirm" != "O" ]; then
    print_error "Installation annulée"
    exit 0
fi

echo ""
print_info "Début de l'installation..."
echo ""

# 1. Mise à jour du système
print_info "Mise à jour du système..."
apt-get update -qq
print_success "Système mis à jour"

# 2. Installation de Node.js et yarn
if ! command -v node &> /dev/null; then
    print_info "Installation de Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt-get install -y nodejs
    print_success "Node.js installé ($(node -v))"
else
    print_success "Node.js déjà installé ($(node -v))"
fi

if ! command -v yarn &> /dev/null; then
    print_info "Installation de Yarn..."
    npm install -g yarn
    print_success "Yarn installé"
else
    print_success "Yarn déjà installé ($(yarn -v))"
fi

# 3. Installation de Nginx
if ! command -v nginx &> /dev/null; then
    print_info "Installation de Nginx..."
    apt-get install -y nginx
    systemctl enable nginx
    print_success "Nginx installé"
else
    print_success "Nginx déjà installé"
fi

# 4. Créer le répertoire d'installation
print_info "Création du répertoire d'installation..."
mkdir -p $INSTALL_PATH
print_success "Répertoire créé: $INSTALL_PATH"

# 5. Copier les fichiers du projet
print_info "Copie des fichiers du projet..."
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Copier le frontend
cp -r $PROJECT_DIR/frontend/* $INSTALL_PATH/
print_success "Fichiers copiés"

# 6. Installation des dépendances et build
print_info "Installation des dépendances..."
cd $INSTALL_PATH
yarn install --production=false
print_success "Dépendances installées"

print_info "Build de l'application..."
yarn build
print_success "Application buildée"

# 7. Configuration de Nginx
print_info "Configuration de Nginx..."

cat > /etc/nginx/sites-available/$DOMAIN_NAME << EOF
server {
    listen 80;
    listen [::]:80;
    
    server_name $DOMAIN_NAME www.$DOMAIN_NAME;
    
    root $INSTALL_PATH/build;
    index index.html;
    
    # Logs
    access_log /var/log/nginx/${DOMAIN_NAME}-access.log;
    error_log /var/log/nginx/${DOMAIN_NAME}-error.log;
    
    # Compression GZIP
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied expired no-cache no-store private must-revalidate;
    gzip_types text/plain text/css text/xml text/javascript
               application/javascript application/json application/xml
               application/rss+xml application/atom+xml image/svg+xml;
    
    # Cache pour fichiers statiques
    location ~* \\.(jpg|jpeg|png|gif|ico|svg|webp)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
        access_log off;
    }
    
    location ~* \\.(css|js)$ {
        expires 1M;
        add_header Cache-Control "public";
        access_log off;
    }
    
    location ~* \\.(woff|woff2|ttf|otf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
        access_log off;
    }
    
    # React Router - SPA configuration
    location / {
        try_files \$uri \$uri/ /index.html;
    }
    
    # En-têtes de sécurité
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    
    # Désactiver les logs pour les fichiers communs
    location = /favicon.ico {
        log_not_found off;
        access_log off;
    }
    
    location = /robots.txt {
        log_not_found off;
        access_log off;
    }
}
EOF

# Créer le lien symbolique
ln -sf /etc/nginx/sites-available/$DOMAIN_NAME /etc/nginx/sites-enabled/

# Supprimer le site par défaut
rm -f /etc/nginx/sites-enabled/default

# Tester la configuration
if nginx -t; then
    print_success "Configuration Nginx validée"
else
    print_error "Erreur dans la configuration Nginx"
    exit 1
fi

# Redémarrer Nginx
systemctl restart nginx
print_success "Nginx configuré et redémarré"

# 8. Configuration des permissions
print_info "Configuration des permissions..."
chown -R www-data:www-data $INSTALL_PATH
chmod -R 755 $INSTALL_PATH
print_success "Permissions configurées"

# 9. Configuration SSL avec Let's Encrypt (optionnel)
if [ ! -z "$SSL_EMAIL" ]; then
    print_info "Installation de Certbot pour SSL..."
    
    if ! command -v certbot &> /dev/null; then
        apt-get install -y certbot python3-certbot-nginx
    fi
    
    print_info "Configuration SSL avec Let's Encrypt..."
    certbot --nginx -d $DOMAIN_NAME -d www.$DOMAIN_NAME --non-interactive --agree-tos --email $SSL_EMAIL --redirect
    
    print_success "SSL configuré"
fi

# 10. Configuration du pare-feu
if command -v ufw &> /dev/null; then
    print_info "Configuration du pare-feu..."
    ufw allow 'OpenSSH'
    ufw allow 'Nginx Full'
    ufw --force enable
    print_success "Pare-feu configuré"
fi

echo ""
echo "================================="
print_success "Installation terminée !"
echo "================================="
echo ""
print_info "Votre site est accessible à:"
if [ ! -z "$SSL_EMAIL" ]; then
    echo "  https://$DOMAIN_NAME"
    echo "  https://www.$DOMAIN_NAME"
else
    echo "  http://$DOMAIN_NAME"
    echo "  http://www.$DOMAIN_NAME"
fi
echo ""
print_info "Fichiers installés dans: $INSTALL_PATH/build"
echo ""

if [ -z "$SSL_EMAIL" ]; then
    print_info "Pour activer SSL ultérieurement:"
    echo "  sudo certbot --nginx -d $DOMAIN_NAME -d www.$DOMAIN_NAME"
    echo ""
fi

print_info "N'oubliez pas de configurer vos DNS pour pointer vers ce serveur!"
echo ""
