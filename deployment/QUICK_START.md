# 🚀 Guide Rapide d'Installation

## Installation en 3 étapes

### Étape 1 : Préparer le serveur

```bash
# Se connecter au serveur
ssh user@votre-serveur.com

# Créer un dossier temporaire
mkdir -p /tmp/s2mc-deploy
cd /tmp/s2mc-deploy
```

### Étape 2 : Transférer les fichiers

**Depuis votre machine locale :**

```bash
# Zipper le projet
cd /app
tar -czf s2mc-website.tar.gz deployment/ frontend/

# Transférer vers le serveur
scp s2mc-website.tar.gz user@votre-serveur.com:/tmp/s2mc-deploy/
```

### Étape 3 : Installer

**Sur le serveur :**

```bash
# Extraire l'archive
cd /tmp/s2mc-deploy
tar -xzf s2mc-website.tar.gz

# Lancer l'installation automatique
cd deployment
chmod +x install.sh
sudo ./install.sh
```

Le script vous guidera à travers :
- ✅ Choix du serveur web (Apache/Nginx)
- ✅ Configuration du domaine
- ✅ Installation SSL (optionnel)
- ✅ Configuration automatique

---

## Installation Alternative : Build Local + Transfert

Si vous préférez builder sur votre machine locale :

### Sur votre machine locale

```bash
# 1. Aller dans le dossier frontend
cd /app/frontend

# 2. Installer les dépendances
yarn install

# 3. Créer le build de production
yarn build

# 4. Transférer le build vers le serveur
scp -r build/* user@votre-serveur.com:/var/www/html/
```

### Sur le serveur

```bash
# Configurer les permissions
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html
```

---

## Configuration Minimale Serveur

### Pour Apache

```bash
# Installer Apache
sudo apt-get update
sudo apt-get install -y apache2

# Activer les modules nécessaires
sudo a2enmod rewrite deflate expires headers

# Copier la configuration
sudo cp apache-multisite.conf.example /etc/apache2/sites-available/s2mc.conf

# Éditer et adapter à votre domaine
sudo nano /etc/apache2/sites-available/s2mc.conf

# Activer le site
sudo a2ensite s2mc.conf
sudo systemctl restart apache2
```

### Pour Nginx

```bash
# Installer Nginx
sudo apt-get update
sudo apt-get install -y nginx

# Copier la configuration
sudo cp nginx-multisite.conf.example /etc/nginx/sites-available/s2mc

# Éditer et adapter à votre domaine
sudo nano /etc/nginx/sites-available/s2mc

# Activer le site
sudo ln -s /etc/nginx/sites-available/s2mc /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

---

## SSL Gratuit avec Let's Encrypt

```bash
# Installer Certbot
sudo apt-get install certbot python3-certbot-apache  # Pour Apache
# OU
sudo apt-get install certbot python3-certbot-nginx   # Pour Nginx

# Obtenir un certificat
sudo certbot --apache -d votre-domaine.com -d www.votre-domaine.com
# OU
sudo certbot --nginx -d votre-domaine.com -d www.votre-domaine.com
```

---

## Configuration DNS

Avant de lancer l'installation, configurez vos DNS :

```
Type    Nom     Valeur              TTL
----------------------------------------------
A       @       IP_DE_VOTRE_SERVEUR 3600
A       www     IP_DE_VOTRE_SERVEUR 3600
```

Attendez 5-10 minutes pour la propagation DNS.

---

## Vérification

```bash
# Tester l'accès local
curl -I http://localhost

# Vérifier les logs
sudo tail -f /var/log/apache2/s2mc-consulting-error.log  # Apache
sudo tail -f /var/log/nginx/s2mc-consulting-error.log    # Nginx

# Tester depuis votre navigateur
http://votre-domaine.com
```

---

## Mise à Jour du Site

```bash
# Utiliser le script de mise à jour
cd /tmp/s2mc-deploy/deployment
sudo ./update.sh
```

---

## Support

En cas de problème :

1. **Vérifier les logs** :
   - Apache : `/var/log/apache2/`
   - Nginx : `/var/log/nginx/`

2. **Vérifier les permissions** :
   ```bash
   ls -la /var/www/s2mc-consulting
   ```

3. **Vérifier le service** :
   ```bash
   sudo systemctl status apache2  # ou nginx
   ```

4. **Tester la configuration** :
   ```bash
   sudo apachectl configtest  # Apache
   sudo nginx -t              # Nginx
   ```

---

## Commandes Utiles

```bash
# Redémarrer le serveur web
sudo systemctl restart apache2  # ou nginx

# Voir les logs en temps réel
sudo tail -f /var/log/apache2/error.log  # Apache
sudo tail -f /var/log/nginx/error.log    # Nginx

# Vérifier l'espace disque
df -h

# Nettoyer les anciennes sauvegardes
sudo rm -rf /var/www/*.backup.*
```
