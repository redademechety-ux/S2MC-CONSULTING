#!/bin/bash

# Script d'installation automatique S2MC Consulting Website
# Pour serveur Linux avec Apache ou Nginx

set -e

echo "================================="
echo "S2MC Consulting - Installation"
echo "================================="
echo ""

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Fonction pour afficher les messages
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

# Demander le choix du serveur web
echo ""
echo "Quel serveur web utilisez-vous ?"
echo "1) Apache"
echo "2) Nginx"
read -p "Votre choix (1 ou 2): " webserver_choice

# Demander le nom de domaine
read -p "Entrez votre nom de domaine (ex: s2mc-consulting.com): " DOMAIN_NAME

# Demander le chemin d'installation
read -p "Chemin d'installation [/var/www/$DOMAIN_NAME]: " INSTALL_PATH
INSTALL_PATH=${INSTALL_PATH:-/var/www/$DOMAIN_NAME}

# Demander l'email pour Let's Encrypt (optionnel)
read -p "Email pour SSL/Let's Encrypt (optionnel, appuyez sur Entrée pour ignorer): " SSL_EMAIL

echo ""
print_info "Configuration:"
echo "  - Domaine: $DOMAIN_NAME"
echo "  - Chemin: $INSTALL_PATH"
echo "  - Serveur: $([ "$webserver_choice" = "1" ] && echo "Apache" || echo "Nginx")"
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

# 2. Installation de Node.js et yarn si nécessaire
if ! command -v node &> /dev/null; then
    print_info "Installation de Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt-get install -y nodejs
    print_success "Node.js installé"
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

# 3. Installation du serveur web
if [ "$webserver_choice" = "1" ]; then
    # Installation Apache
    if ! command -v apache2 &> /dev/null; then
        print_info "Installation d'Apache..."
        apt-get install -y apache2
        systemctl enable apache2
        print_success "Apache installé"
    else
        print_success "Apache déjà installé"
    fi
else
    # Installation Nginx
    if ! command -v nginx &> /dev/null; then
        print_info "Installation de Nginx..."
        apt-get install -y nginx
        systemctl enable nginx
        print_success "Nginx installé"
    else
        print_success "Nginx déjà installé"
    fi
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

# 7. Configuration du serveur web
if [ "$webserver_choice" = "1" ]; then
    # Configuration Apache
    print_info "Configuration d'Apache..."
    
    cat > /etc/apache2/sites-available/$DOMAIN_NAME.conf << EOF
<VirtualHost *:80>
    ServerName $DOMAIN_NAME
    ServerAlias www.$DOMAIN_NAME
    
    DocumentRoot $INSTALL_PATH/build
    
    <Directory $INSTALL_PATH/build>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
        
        # React Router configuration
        RewriteEngine On
        RewriteBase /
        RewriteRule ^index\\.html$ - [L]
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteCond %{REQUEST_FILENAME} !-d
        RewriteRule . /index.html [L]
    </Directory>
    
    # Compression
    <IfModule mod_deflate.c>
        AddOutputFilterByType DEFLATE text/html text/plain text/xml text/css text/javascript application/javascript
    </IfModule>
    
    # Cache statique
    <IfModule mod_expires.c>
        ExpiresActive On
        ExpiresByType image/jpg "access plus 1 year"
        ExpiresByType image/jpeg "access plus 1 year"
        ExpiresByType image/gif "access plus 1 year"
        ExpiresByType image/png "access plus 1 year"
        ExpiresByType text/css "access plus 1 month"
        ExpiresByType application/javascript "access plus 1 month"
    </IfModule>
    
    ErrorLog \${APACHE_LOG_DIR}/$DOMAIN_NAME-error.log
    CustomLog \${APACHE_LOG_DIR}/$DOMAIN_NAME-access.log combined
</VirtualHost>
EOF

    # Activer les modules nécessaires
    a2enmod rewrite
    a2enmod deflate
    a2enmod expires
    
    # Activer le site
    a2ensite $DOMAIN_NAME.conf
    
    # Désactiver le site par défaut si c'est le premier site
    a2dissite 000-default.conf 2>/dev/null || true
    
    # Redémarrer Apache
    systemctl restart apache2
    
    print_success "Apache configuré"
    
else
    # Configuration Nginx
    print_info "Configuration de Nginx..."
    
    cat > /etc/nginx/sites-available/$DOMAIN_NAME << EOF
server {
    listen 80;
    listen [::]:80;
    
    server_name $DOMAIN_NAME www.$DOMAIN_NAME;
    
    root $INSTALL_PATH/build;
    index index.html;
    
    # Compression
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
    
    # Cache statique
    location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # React Router
    location / {
        try_files \$uri \$uri/ /index.html;
    }
    
    # Sécurité
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    
    access_log /var/log/nginx/$DOMAIN_NAME-access.log;
    error_log /var/log/nginx/$DOMAIN_NAME-error.log;
}
EOF

    # Créer le lien symbolique
    ln -sf /etc/nginx/sites-available/$DOMAIN_NAME /etc/nginx/sites-enabled/
    
    # Supprimer le site par défaut si c'est le premier site
    rm -f /etc/nginx/sites-enabled/default
    
    # Tester la configuration
    nginx -t
    
    # Redémarrer Nginx
    systemctl restart nginx
    
    print_success "Nginx configuré"
fi

# 8. Configuration des permissions
print_info "Configuration des permissions..."
chown -R www-data:www-data $INSTALL_PATH
chmod -R 755 $INSTALL_PATH
print_success "Permissions configurées"

# 9. Configuration SSL avec Let's Encrypt (optionnel)
if [ ! -z "$SSL_EMAIL" ]; then
    print_info "Installation de Certbot pour SSL..."
    
    if ! command -v certbot &> /dev/null; then
        apt-get install -y certbot
        
        if [ "$webserver_choice" = "1" ]; then
            apt-get install -y python3-certbot-apache
        else
            apt-get install -y python3-certbot-nginx
        fi
    fi
    
    print_info "Configuration SSL avec Let's Encrypt..."
    
    if [ "$webserver_choice" = "1" ]; then
        certbot --apache -d $DOMAIN_NAME -d www.$DOMAIN_NAME --non-interactive --agree-tos --email $SSL_EMAIL --redirect
    else
        certbot --nginx -d $DOMAIN_NAME -d www.$DOMAIN_NAME --non-interactive --agree-tos --email $SSL_EMAIL --redirect
    fi
    
    print_success "SSL configuré"
fi

# 10. Configuration du pare-feu (optionnel)
if command -v ufw &> /dev/null; then
    print_info "Configuration du pare-feu..."
    ufw allow 'OpenSSH'
    
    if [ "$webserver_choice" = "1" ]; then
        ufw allow 'Apache Full'
    else
        ufw allow 'Nginx Full'
    fi
    
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
    print_info "Pour activer SSL ultérieurement, exécutez:"
    if [ "$webserver_choice" = "1" ]; then
        echo "  sudo certbot --apache -d $DOMAIN_NAME -d www.$DOMAIN_NAME"
    else
        echo "  sudo certbot --nginx -d $DOMAIN_NAME -d www.$DOMAIN_NAME"
    fi
    echo ""
fi

print_info "N'oubliez pas de configurer vos DNS pour pointer vers ce serveur!"
echo ""
