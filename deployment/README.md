# Guide d'Installation - S2MC Consulting Website

## 📋 Prérequis

- Serveur Linux (Ubuntu 20.04+ ou Debian 10+ recommandé)
- Accès root ou sudo
- Nom de domaine configuré (optionnel pour les tests)
- Connexion Internet

## 🚀 Installation Automatique

### Méthode 1 : Script d'installation complet

```bash
# 1. Télécharger le projet sur votre serveur
scp -r /app/* user@votre-serveur:/tmp/s2mc-website/

# 2. Se connecter au serveur
ssh user@votre-serveur

# 3. Exécuter le script d'installation
cd /tmp/s2mc-website/deployment
chmod +x install.sh
sudo ./install.sh
```

Le script vous demandera :
- Le choix du serveur web (Apache ou Nginx)
- Votre nom de domaine
- Le chemin d'installation
- Votre email pour SSL (optionnel)

### Méthode 2 : Installation manuelle rapide

```bash
# 1. Télécharger et extraire le build
cd /var/www
sudo mkdir s2mc-consulting
cd s2mc-consulting

# 2. Copier les fichiers build
sudo cp -r /chemin/vers/frontend/build/* .

# 3. Configurer les permissions
sudo chown -R www-data:www-data /var/www/s2mc-consulting
sudo chmod -R 755 /var/www/s2mc-consulting
```

## 🔧 Configuration Manuelle

### Pour Apache

```bash
# 1. Créer le fichier de configuration
sudo nano /etc/apache2/sites-available/s2mc-consulting.conf
```

Coller la configuration suivante :

```apache
<VirtualHost *:80>
    ServerName votre-domaine.com
    ServerAlias www.votre-domaine.com
    
    DocumentRoot /var/www/s2mc-consulting
    
    <Directory /var/www/s2mc-consulting>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
        
        RewriteEngine On
        RewriteBase /
        RewriteRule ^index\.html$ - [L]
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteCond %{REQUEST_FILENAME} !-d
        RewriteRule . /index.html [L]
    </Directory>
    
    ErrorLog ${APACHE_LOG_DIR}/s2mc-error.log
    CustomLog ${APACHE_LOG_DIR}/s2mc-access.log combined
</VirtualHost>
```

```bash
# 2. Activer les modules et le site
sudo a2enmod rewrite
sudo a2enmod deflate
sudo a2enmod expires
sudo a2ensite s2mc-consulting.conf
sudo a2dissite 000-default.conf

# 3. Redémarrer Apache
sudo systemctl restart apache2
```

### Pour Nginx

```bash
# 1. Créer le fichier de configuration
sudo nano /etc/nginx/sites-available/s2mc-consulting
```

Coller la configuration suivante :

```nginx
server {
    listen 80;
    listen [::]:80;
    
    server_name votre-domaine.com www.votre-domaine.com;
    
    root /var/www/s2mc-consulting;
    index index.html;
    
    # Compression
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml;
    
    # Cache statique
    location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # React Router
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    # Sécurité
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    
    access_log /var/log/nginx/s2mc-access.log;
    error_log /var/log/nginx/s2mc-error.log;
}
```

```bash
# 2. Activer le site
sudo ln -s /etc/nginx/sites-available/s2mc-consulting /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default

# 3. Tester et redémarrer Nginx
sudo nginx -t
sudo systemctl restart nginx
```

## 🔒 Configuration SSL avec Let's Encrypt

### Installation de Certbot

```bash
# Pour Ubuntu/Debian
sudo apt-get update
sudo apt-get install certbot

# Pour Apache
sudo apt-get install python3-certbot-apache

# Pour Nginx
sudo apt-get install python3-certbot-nginx
```

### Obtenir un certificat SSL

```bash
# Pour Apache
sudo certbot --apache -d votre-domaine.com -d www.votre-domaine.com

# Pour Nginx
sudo certbot --nginx -d votre-domaine.com -d www.votre-domaine.com
```

### Renouvellement automatique

```bash
# Tester le renouvellement
sudo certbot renew --dry-run

# Le renouvellement automatique est configuré par défaut via cron
```

## 🌐 Configuration DNS

Configurez vos enregistrements DNS chez votre registrar :

```
Type    Nom                 Valeur
----------------------------------------
A       @                   IP_DU_SERVEUR
A       www                 IP_DU_SERVEUR
```

Ou pour un sous-domaine :

```
Type    Nom                 Valeur
----------------------------------------
A       s2mc                IP_DU_SERVEUR
```

## 📦 Build local avant déploiement

Si vous souhaitez builder l'application localement avant de la transférer :

```bash
# Sur votre machine locale
cd /app/frontend

# Installer les dépendances
yarn install

# Créer le build de production
yarn build

# Le dossier 'build' contient maintenant les fichiers à déployer
# Transférer vers le serveur
scp -r build/* user@serveur:/var/www/s2mc-consulting/
```

## 🔍 Vérification de l'installation

```bash
# Vérifier le statut du serveur web
# Pour Apache
sudo systemctl status apache2

# Pour Nginx
sudo systemctl status nginx

# Vérifier les logs
# Apache
sudo tail -f /var/log/apache2/s2mc-error.log

# Nginx
sudo tail -f /var/log/nginx/s2mc-error.log

# Tester l'accès
curl -I http://localhost
```

## 🔥 Configuration du Pare-feu (UFW)

```bash
# Installer UFW si nécessaire
sudo apt-get install ufw

# Autoriser SSH
sudo ufw allow OpenSSH

# Autoriser HTTP et HTTPS
sudo ufw allow 'Nginx Full'  # Pour Nginx
# OU
sudo ufw allow 'Apache Full'  # Pour Apache

# Activer le pare-feu
sudo ufw enable

# Vérifier le statut
sudo ufw status
```

## 🚨 Dépannage

### Le site ne s'affiche pas

```bash
# Vérifier les permissions
ls -la /var/www/s2mc-consulting

# Corriger si nécessaire
sudo chown -R www-data:www-data /var/www/s2mc-consulting
sudo chmod -R 755 /var/www/s2mc-consulting
```

### Erreur 404 sur les routes React

Vérifiez que le module rewrite est activé :

```bash
# Apache
sudo a2enmod rewrite
sudo systemctl restart apache2

# Nginx - vérifier la directive try_files dans la config
```

### Erreur de permissions

```bash
# Assurez-vous que www-data est le propriétaire
sudo chown -R www-data:www-data /var/www/s2mc-consulting
sudo find /var/www/s2mc-consulting -type d -exec chmod 755 {} \;
sudo find /var/www/s2mc-consulting -type f -exec chmod 644 {} \;
```

## 📞 Support

Pour toute question ou problème :
- Vérifiez les logs du serveur web
- Vérifiez la configuration DNS
- Assurez-vous que les ports 80 et 443 sont ouverts

## 📝 Notes Importantes

1. **Sauvegarde** : Créez toujours une sauvegarde avant de modifier la configuration
2. **Sécurité** : Utilisez toujours SSL en production
3. **Mise à jour** : Gardez votre système et vos packages à jour
4. **Monitoring** : Surveillez les logs régulièrement

## 🔄 Mise à jour du site

Pour mettre à jour le contenu du site :

```bash
# 1. Builder la nouvelle version
cd /app/frontend
yarn build

# 2. Sauvegarder l'ancienne version
sudo cp -r /var/www/s2mc-consulting /var/www/s2mc-consulting.backup

# 3. Déployer la nouvelle version
sudo rm -rf /var/www/s2mc-consulting/*
sudo cp -r build/* /var/www/s2mc-consulting/

# 4. Corriger les permissions
sudo chown -R www-data:www-data /var/www/s2mc-consulting

# 5. Redémarrer le serveur web
sudo systemctl restart apache2  # ou nginx
```
