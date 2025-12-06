# 🏢 Scénarios d'Hébergement - S2MC Consulting

Ce guide couvre différents scénarios d'hébergement pour votre site S2MC Consulting.

---

## 📦 Scénario 1 : Hébergement Mutualisé (Shared Hosting)

### Limitations
- Pas d'accès root/sudo
- Panel de contrôle (cPanel, Plesk, etc.)
- Node.js peut ne pas être disponible

### Solution : Build local + Upload FTP

```bash
# 1. Sur votre machine locale
cd /app/frontend
yarn install
yarn build

# 2. Uploader via FTP/SFTP
# Uploadez tout le contenu du dossier 'build' vers public_html/
```

### Configuration .htaccess (Apache)

Créez un fichier `.htaccess` dans le dossier racine :

```apache
# Activer le moteur de réécriture
RewriteEngine On

# Rediriger tout vers index.html sauf fichiers existants
RewriteBase /
RewriteRule ^index\.html$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.html [L]

# Compression GZIP
<IfModule mod_deflate.c>
    AddOutputFilterByType DEFLATE text/html text/plain text/xml text/css text/javascript application/javascript
</IfModule>

# Cache navigateur
<IfModule mod_expires.c>
    ExpiresActive On
    ExpiresByType image/jpg "access plus 1 year"
    ExpiresByType image/jpeg "access plus 1 year"
    ExpiresByType image/png "access plus 1 year"
    ExpiresByType image/gif "access plus 1 year"
    ExpiresByType text/css "access plus 1 month"
    ExpiresByType application/javascript "access plus 1 month"
</IfModule>

# Sécurité
<IfModule mod_headers.c>
    Header set X-Content-Type-Options "nosniff"
    Header set X-Frame-Options "SAMEORIGIN"
    Header set X-XSS-Protection "1; mode=block"
</IfModule>
```

---

## 🖥️ Scénario 2 : VPS Linux avec Plesk/cPanel

### Avec cPanel

1. **Upload des fichiers** :
   - Utilisez le gestionnaire de fichiers cPanel
   - Uploadez dans `public_html`

2. **Configuration** :
   - Activez SSL via cPanel > SSL/TLS
   - Configurez le .htaccess comme ci-dessus

### Avec Plesk

1. **Upload des fichiers** :
   - File Manager > httpdocs
   - Uploadez le contenu de 'build'

2. **Configuration** :
   - Plesk > Hosting Settings > Document Root = /httpdocs
   - Activez SSL via Plesk > SSL/TLS Certificates

---

## ☁️ Scénario 3 : VPS Linux (Accès Root Complet)

### Installation Automatique

```bash
# 1. Transférer le package
scp s2mc-website.tar.gz root@votre-serveur:/tmp/

# 2. Se connecter
ssh root@votre-serveur

# 3. Installer
cd /tmp
tar -xzf s2mc-website.tar.gz
cd s2mc-website-*/deployment
./install.sh
```

### Installation Manuelle

Suivez les instructions dans README.md pour :
- Apache : Configuration complète avec modules
- Nginx : Configuration optimisée
- SSL : Let's Encrypt gratuit

---

## 🔄 Scénario 4 : Hébergement Multisite (Plusieurs domaines)

### Configuration Apache Multisite

```apache
# Premier site - s2mc-consulting.com
<VirtualHost *:80>
    ServerName s2mc-consulting.com
    ServerAlias www.s2mc-consulting.com
    DocumentRoot /var/www/s2mc-consulting
    # ... configuration ...
</VirtualHost>

# Deuxième site - autre-domaine.com
<VirtualHost *:80>
    ServerName autre-domaine.com
    ServerAlias www.autre-domaine.com
    DocumentRoot /var/www/autre-site
    # ... configuration ...
</VirtualHost>
```

### Configuration Nginx Multisite

```nginx
# Premier site
server {
    listen 80;
    server_name s2mc-consulting.com www.s2mc-consulting.com;
    root /var/www/s2mc-consulting;
    # ... configuration ...
}

# Deuxième site
server {
    listen 80;
    server_name autre-domaine.com www.autre-domaine.com;
    root /var/www/autre-site;
    # ... configuration ...
}
```

---

## 📱 Scénario 5 : Sous-domaine

### DNS

```
Type    Nom              Valeur
-----------------------------------
A       consulting       IP_DU_SERVEUR
```

### Apache

```apache
<VirtualHost *:80>
    ServerName consulting.votre-domaine.com
    DocumentRoot /var/www/s2mc-consulting
    # ... configuration ...
</VirtualHost>
```

### Nginx

```nginx
server {
    listen 80;
    server_name consulting.votre-domaine.com;
    root /var/www/s2mc-consulting;
    # ... configuration ...
}
```

---

## 📂 Scénario 6 : Sous-répertoire (example.com/s2mc)

### Structure

```
/var/www/html/
├── index.html          # Site principal
├── s2mc/              # Site S2MC
│   ├── index.html
│   ├── static/
│   └── ...
```

### Configuration .htaccess

```apache
# Dans /var/www/html/s2mc/.htaccess
RewriteEngine On
RewriteBase /s2mc/
RewriteRule ^index\.html$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /s2mc/index.html [L]
```

### ⚠️ Important pour React Router

Vous devez modifier le `package.json` avant le build :

```json
{
  "homepage": "/s2mc"
}
```

Puis rebuild :

```bash
yarn build
```

---

## 🌐 Scénario 7 : CDN (CloudFlare, AWS CloudFront)

### Avec CloudFlare

1. **Hébergez normalement** sur votre serveur
2. **Ajoutez le site à CloudFlare** :
   - Ajoutez votre domaine
   - Changez les nameservers
3. **Configuration CloudFlare** :
   - SSL : Full (Strict)
   - Cache Level : Standard
   - Always Use HTTPS : ON
   - Auto Minify : HTML, CSS, JS

### Avec AWS CloudFront

1. **Upload sur S3** :
```bash
aws s3 sync build/ s3://votre-bucket/
aws s3 website s3://votre-bucket/ --index-document index.html --error-document index.html
```

2. **Créer une distribution CloudFront** :
   - Origin : Votre bucket S3
   - Default Root Object : index.html
   - Custom Error Response : 404 → /index.html

---

## 🐳 Scénario 8 : Docker

### Dockerfile

```dockerfile
FROM nginx:alpine

# Copier les fichiers build
COPY build/ /usr/share/nginx/html/

# Configuration Nginx personnalisée
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

### nginx.conf pour Docker

```nginx
server {
    listen 80;
    server_name _;
    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

### Build et Run

```bash
# Build l'application
yarn build

# Build l'image Docker
docker build -t s2mc-consulting .

# Run le container
docker run -d -p 80:80 s2mc-consulting
```

---

## ☸️ Scénario 9 : Kubernetes

### Deployment YAML

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: s2mc-consulting
spec:
  replicas: 2
  selector:
    matchLabels:
      app: s2mc-consulting
  template:
    metadata:
      labels:
        app: s2mc-consulting
    spec:
      containers:
      - name: s2mc-consulting
        image: s2mc-consulting:latest
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: s2mc-consulting-service
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 80
  selector:
    app: s2mc-consulting
```

---

## 🔍 Tableau Comparatif

| Scénario | Difficulté | Contrôle | Performance | Coût |
|----------|------------|----------|-------------|------|
| Mutualisé | ⭐ | Faible | Moyenne | $ |
| VPS cPanel/Plesk | ⭐⭐ | Moyen | Bonne | $$ |
| VPS Linux | ⭐⭐⭐ | Total | Excellente | $$ |
| Docker | ⭐⭐⭐⭐ | Total | Excellente | $$$ |
| Kubernetes | ⭐⭐⭐⭐⭐ | Total | Excellente | $$$$ |

---

## 🎯 Recommandation par Usage

### Site Vitrine Simple (Votre cas)
- **Idéal** : VPS Linux avec script automatique
- **Budget serré** : Hébergement mutualisé
- **Simplicité max** : VPS avec Plesk/cPanel

### Site avec Trafic Important
- VPS Linux optimisé
- CDN (CloudFlare gratuit)

### Infrastructure Professionnelle
- VPS Linux + Load Balancer
- Docker / Kubernetes

---

## 📞 Support par Hébergeur

### Vérifications communes

```bash
# Tester PHP (si hébergeur mixte)
php -v

# Tester Apache
apache2 -v

# Vérifier les modules Apache
apache2ctl -M | grep rewrite

# Tester Nginx
nginx -v

# Vérifier l'espace disque
df -h

# Vérifier les permissions
ls -la /var/www/
```

---

## ✅ Checklist Avant Mise en Production

- [ ] DNS configurés et propagés
- [ ] SSL/HTTPS activé
- [ ] Fichiers uploadés et permissions OK
- [ ] .htaccess ou configuration serveur OK
- [ ] Test sur tous les navigateurs
- [ ] Test responsive (mobile, tablette)
- [ ] Vérification des liens internes
- [ ] Test de la navigation (smooth scroll)
- [ ] Vérification email de contact cliquable
- [ ] Google Analytics installé (optionnel)
- [ ] Sitemap créé (optionnel)
- [ ] Robots.txt configuré (optionnel)

---

Choisissez le scénario qui correspond à votre infrastructure et suivez les instructions correspondantes !
