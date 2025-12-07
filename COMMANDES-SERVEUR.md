# 🚀 Commandes d'Installation sur Serveur Linux

## ✅ Configuration Actuelle

- **Domaine** : `s2mc-consulting.com` (en minuscules)
- **Serveur** : Nginx
- **Chemin** : `/var/www/s2mc-consulting`
- **Repository GitHub** : https://github.com/redademechety-ux/S2MC-CONSULTING

---

## 📋 Prérequis Serveur

Avant de commencer, assurez-vous que :
- ✅ Vous avez accès SSH au serveur
- ✅ Vous avez les droits sudo/root
- ✅ Le serveur est sous Linux (Ubuntu/Debian/CentOS)
- ✅ Les DNS de `s2mc-consulting.com` pointent vers l'IP du serveur

---

## 🔧 Installation Complète (Méthode Recommandée)

### Sur votre serveur Linux, exécutez :

```bash
# 1. Cloner le repository depuis GitHub
git clone https://github.com/redademechety-ux/S2MC-CONSULTING.git

# 2. Aller dans le dossier deployment
cd S2MC-CONSULTING/deployment

# 3. Rendre le script exécutable
chmod +x install-nginx.sh

# 4. Lancer l'installation automatique
sudo ./install-nginx.sh
```

### ⚡ Version en Une Seule Ligne :

```bash
git clone https://github.com/redademechety-ux/S2MC-CONSULTING.git && cd S2MC-CONSULTING/deployment && chmod +x install-nginx.sh && sudo ./install-nginx.sh
```

---

## 📝 Ce que le script vous demandera :

1. **Nom de domaine** 
   - Appuyez sur `Entrée` pour accepter : `s2mc-consulting.com`
   - Ou tapez votre propre domaine

2. **Chemin d'installation**
   - Appuyez sur `Entrée` pour accepter : `/var/www/s2mc-consulting`
   - Ou spécifiez un autre chemin

3. **Email pour SSL/HTTPS** (optionnel)
   - Tapez votre email pour activer HTTPS automatiquement avec Let's Encrypt
   - Ou appuyez sur `Entrée` pour ignorer (vous pourrez l'ajouter plus tard)

4. **Confirmation**
   - Tapez `o` puis `Entrée` pour continuer

---

## 🎯 Ce que le script va faire automatiquement :

1. ✅ Mise à jour du système
2. ✅ Installation de Node.js et Yarn
3. ✅ Installation de Nginx
4. ✅ Création du répertoire `/var/www/s2mc-consulting`
5. ✅ Copie des fichiers du projet
6. ✅ Installation des dépendances (yarn install)
7. ✅ Build de l'application React
8. ✅ Configuration de Nginx avec optimisations :
   - Compression GZIP
   - Cache navigateur
   - Support React Router
   - En-têtes de sécurité
9. ✅ Configuration SSL avec Let's Encrypt (si email fourni)
10. ✅ Configuration du pare-feu UFW
11. ✅ Redémarrage de Nginx

**Durée estimée** : 5-10 minutes

---

## 🌐 Configuration DNS Requise

Avant l'installation, configurez vos DNS chez votre registrar :

```
Type    Nom     Valeur              TTL
----------------------------------------
A       @       IP_DE_VOTRE_SERVEUR 3600
A       www     IP_DE_VOTRE_SERVEUR 3600
```

**Note** : La propagation DNS peut prendre de 5 minutes à 24 heures

---

## 🔍 Vérification Post-Installation

### 1. Vérifier que Nginx fonctionne

```bash
sudo systemctl status nginx
```

Vous devriez voir : `Active: active (running)`

### 2. Vérifier les fichiers installés

```bash
ls -la /var/www/s2mc-consulting/build
```

Vous devriez voir : `index.html`, `static/`, etc.

### 3. Tester l'accès local

```bash
curl -I http://localhost
```

Vous devriez voir : `HTTP/1.1 200 OK`

### 4. Tester depuis votre navigateur

- Ouvrez : `http://s2mc-consulting.com`
- Ou si DNS pas encore propagés : `http://IP_DE_VOTRE_SERVEUR`

### 5. Vérifier SSL (si configuré)

```bash
sudo certbot certificates
```

---

## 🔄 Mise à Jour du Site

Quand vous voulez mettre à jour le site après des modifications :

```bash
# 1. Aller dans le dossier du projet
cd ~/S2MC-CONSULTING  # ou le chemin où vous avez cloné

# 2. Récupérer les dernières modifications depuis GitHub
git pull origin main

# 3. Lancer la mise à jour
cd deployment
sudo ./update-nginx.sh
```

Le script de mise à jour :
- ✅ Crée une sauvegarde automatique
- ✅ Rebuild l'application
- ✅ Remplace les fichiers
- ✅ Corrige les permissions
- ✅ Redémarre Nginx

---

## 🔐 Activer SSL/HTTPS (si pas fait pendant l'installation)

```bash
# Installer Certbot si pas déjà installé
sudo apt-get update
sudo apt-get install certbot python3-certbot-nginx

# Obtenir un certificat SSL gratuit
sudo certbot --nginx -d s2mc-consulting.com -d www.s2mc-consulting.com

# Suivre les instructions à l'écran
```

Le certificat se renouvellera automatiquement tous les 3 mois.

---

## 📊 Commandes Utiles

### Nginx

```bash
# Redémarrer Nginx
sudo systemctl restart nginx

# Arrêter Nginx
sudo systemctl stop nginx

# Démarrer Nginx
sudo systemctl start nginx

# Voir le statut
sudo systemctl status nginx

# Tester la configuration
sudo nginx -t

# Recharger la configuration sans redémarrage
sudo systemctl reload nginx
```

### Logs

```bash
# Logs d'erreur en temps réel
sudo tail -f /var/log/nginx/s2mc-consulting.com-error.log

# Logs d'accès en temps réel
sudo tail -f /var/log/nginx/s2mc-consulting.com-access.log

# Dernières 100 lignes des logs d'erreur
sudo tail -n 100 /var/log/nginx/s2mc-consulting.com-error.log
```

### Permissions

```bash
# Corriger les permissions si nécessaire
sudo chown -R www-data:www-data /var/www/s2mc-consulting
sudo chmod -R 755 /var/www/s2mc-consulting
```

### Pare-feu

```bash
# Voir le statut du pare-feu
sudo ufw status

# Autoriser HTTP
sudo ufw allow 'Nginx HTTP'

# Autoriser HTTPS
sudo ufw allow 'Nginx HTTPS'

# Autoriser HTTP et HTTPS
sudo ufw allow 'Nginx Full'
```

---

## 🆘 Dépannage

### Problème : Le site ne s'affiche pas

**1. Vérifiez que Nginx tourne**
```bash
sudo systemctl status nginx
```
Si pas actif : `sudo systemctl start nginx`

**2. Vérifiez les logs**
```bash
sudo tail -n 50 /var/log/nginx/s2mc-consulting.com-error.log
```

**3. Vérifiez la configuration Nginx**
```bash
sudo nginx -t
```
Si erreur, corrigez et relancez : `sudo systemctl restart nginx`

**4. Vérifiez les DNS**
```bash
nslookup s2mc-consulting.com
```
L'IP doit correspondre à celle de votre serveur

### Problème : Erreur 404 sur les pages

```bash
# Vérifier que la configuration Nginx inclut le support React Router
sudo cat /etc/nginx/sites-available/s2mc-consulting.com | grep "try_files"
```
Devrait contenir : `try_files $uri $uri/ /index.html;`

### Problème : SSL ne fonctionne pas

```bash
# Réinstaller le certificat
sudo certbot --nginx -d s2mc-consulting.com -d www.s2mc-consulting.com

# Forcer le renouvellement
sudo certbot renew --force-renewal
```

### Problème : Permission denied

```bash
# Corriger toutes les permissions
sudo chown -R www-data:www-data /var/www/s2mc-consulting
sudo find /var/www/s2mc-consulting -type d -exec chmod 755 {} \;
sudo find /var/www/s2mc-consulting -type f -exec chmod 644 {} \;
```

---

## 📞 Support

Si vous rencontrez des problèmes :

1. **Consultez les logs** : Ils contiennent souvent la solution
2. **Vérifiez la documentation** :
   - `/app/deployment/README.md`
   - `/app/deployment/LISEZ-MOI.txt`
3. **Testez la configuration** : `sudo nginx -t`

---

## ✅ Checklist Complète

Avant de commencer :
- [ ] Serveur Linux accessible via SSH
- [ ] Droits sudo/root disponibles
- [ ] DNS configurés et pointant vers le serveur
- [ ] Ports 80 et 443 ouverts

Après installation :
- [ ] Nginx est actif : `sudo systemctl status nginx`
- [ ] Site accessible : http://s2mc-consulting.com
- [ ] SSL fonctionne : https://s2mc-consulting.com (si configuré)
- [ ] Toutes les sections du site s'affichent
- [ ] Navigation smooth scroll fonctionne
- [ ] Site responsive sur mobile

---

## 🎉 Vous êtes prêt !

### Commande complète d'installation :

```bash
git clone https://github.com/redademechety-ux/S2MC-CONSULTING.git && \
cd S2MC-CONSULTING/deployment && \
chmod +x install-nginx.sh && \
sudo ./install-nginx.sh
```

**Copiez-collez cette commande sur votre serveur et c'est parti ! 🚀**

---

Pour plus d'informations, consultez :
- 📖 `INSTRUCTIONS-FINALES.md` - Guide complet
- 📖 `deployment/LISEZ-MOI.txt` - Guide rapide en français
- 📖 `deployment/README.md` - Documentation technique
