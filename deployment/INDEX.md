# 📚 Index de la Documentation - S2MC Consulting

## 🚀 Démarrage Rapide

**Nouveau sur Linux ?** → Lisez `LISEZ-MOI.txt`  
**Pressé ?** → Consultez `QUICK_START.md`  
**Installation complète ?** → Suivez `README.md`

---

## 📁 Fichiers Disponibles

### 📄 Documentation

| Fichier | Description | Langue |
|---------|-------------|--------|
| **LISEZ-MOI.txt** | Guide de démarrage simple | 🇫🇷 Français |
| **README.md** | Documentation technique complète | 🇬🇧 English |
| **QUICK_START.md** | Installation rapide en 3 étapes | 🇬🇧 English |
| **SCENARIOS-HEBERGEMENT.md** | Guide pour différents hébergeurs | 🇫🇷 Français |
| **INDEX.md** | Ce fichier - vue d'ensemble | 🇫🇷 Français |

### 🔧 Scripts d'Installation

| Script | Usage | Description |
|--------|-------|-------------|
| **install.sh** | `sudo ./install.sh` | Installation automatique complète |
| **update.sh** | `sudo ./update.sh` | Mise à jour du site |
| **build.sh** | `./build.sh` | Build local de l'application |
| **create-package.sh** | `./create-package.sh` | Créer un package déployable |

### ⚙️ Fichiers de Configuration

| Fichier | Pour | Usage |
|---------|------|-------|
| **apache-multisite.conf.example** | Apache | Configuration serveur web |
| **nginx-multisite.conf.example** | Nginx | Configuration serveur web |

---

## 🎯 Guides par Situation

### "Je veux installer rapidement"
1. Lisez `LISEZ-MOI.txt`
2. Exécutez `./install.sh`
3. Suivez les instructions

### "J'ai un hébergement mutualisé"
1. Consultez `SCENARIOS-HEBERGEMENT.md` → Scénario 1
2. Utilisez `./build.sh` pour créer le build
3. Uploadez via FTP/cPanel

### "J'ai un VPS avec cPanel/Plesk"
1. Consultez `SCENARIOS-HEBERGEMENT.md` → Scénario 2
2. Utilisez l'interface graphique pour l'upload
3. Configurez SSL via le panel

### "J'ai un VPS Linux (accès root)"
1. Exécutez `./install.sh` (méthode recommandée)
2. Ou suivez `README.md` pour installation manuelle
3. Le script gère tout automatiquement

### "Je veux héberger plusieurs sites"
1. Consultez `SCENARIOS-HEBERGEMENT.md` → Scénario 4
2. Utilisez les fichiers .conf.example comme modèles
3. Créez une configuration par site

### "Je veux utiliser Docker"
1. Consultez `SCENARIOS-HEBERGEMENT.md` → Scénario 8
2. Dockerfile et configuration fournis
3. Build et deploy en quelques commandes

### "Je dois mettre à jour le site"
1. Exécutez `./update.sh`
2. Une sauvegarde sera créée automatiquement
3. Le script rebuild et redéploie

---

## 🔍 Résolution de Problèmes

### Le site ne s'affiche pas
→ Consultez `README.md` section "Dépannage"

### Erreur 404 sur les routes
→ Vérifiez configuration Apache/Nginx  
→ `apache-multisite.conf.example` ou `nginx-multisite.conf.example`

### Problème de permissions
```bash
sudo chown -R www-data:www-data /var/www/s2mc-consulting
sudo chmod -R 755 /var/www/s2mc-consulting
```

### SSL ne fonctionne pas
```bash
sudo certbot --apache -d votre-domaine.com
# ou
sudo certbot --nginx -d votre-domaine.com
```

---

## 📊 Architecture du Projet

```
deployment/
├── 📄 LISEZ-MOI.txt                    # Démarrage simple (FR)
├── 📄 INDEX.md                         # Ce fichier (FR)
├── 📄 README.md                        # Doc complète (EN)
├── 📄 QUICK_START.md                   # Guide rapide (EN)
├── 📄 SCENARIOS-HEBERGEMENT.md         # Scénarios hébergement (FR)
│
├── 🔧 install.sh                       # Installation auto
├── 🔧 update.sh                        # Mise à jour
├── 🔧 build.sh                         # Build local
├── 🔧 create-package.sh                # Créer package
│
├── ⚙️  apache-multisite.conf.example   # Config Apache
└── ⚙️  nginx-multisite.conf.example    # Config Nginx
```

---

## ✅ Checklist d'Installation

- [ ] Lire la documentation appropriée
- [ ] Vérifier les prérequis serveur
- [ ] Configurer DNS
- [ ] Transférer les fichiers sur le serveur
- [ ] Exécuter le script d'installation
- [ ] Vérifier que le site fonctionne
- [ ] Configurer SSL
- [ ] Tester sur mobile et desktop
- [ ] Faire une sauvegarde

---

## 🎓 Niveaux de Compétence

### Débutant
- Utilisez `install.sh` (fait tout automatiquement)
- Lisez `LISEZ-MOI.txt`
- Suivez `QUICK_START.md`

### Intermédiaire
- Installation manuelle via `README.md`
- Personnalisation des configurations
- Mise en place multisite

### Avancé
- Docker / Kubernetes
- Optimisations personnalisées
- Load balancing et CDN

---

## 📞 Aide

### Documentation
1. Lisez d'abord `LISEZ-MOI.txt`
2. Consultez `README.md` pour détails techniques
3. Vérifiez `SCENARIOS-HEBERGEMENT.md` pour votre cas

### Logs
```bash
# Apache
sudo tail -f /var/log/apache2/s2mc-*-error.log

# Nginx
sudo tail -f /var/log/nginx/s2mc-*-error.log
```

### Statut Services
```bash
# Apache
sudo systemctl status apache2

# Nginx
sudo systemctl status nginx
```

---

## 🔄 Workflow Typique

```
1. Développement Local
   └─> build.sh (créer le build)

2. Préparation
   └─> create-package.sh (créer l'archive)

3. Transfert
   └─> scp vers le serveur

4. Installation
   └─> install.sh (installation auto)

5. Mise à jour future
   └─> update.sh (mise à jour)
```

---

## 🌟 Points Importants

⚠️ **Toujours faire une sauvegarde avant mise à jour**  
⚠️ **Configurer DNS avant l'installation**  
⚠️ **Utiliser HTTPS en production (SSL)**  
⚠️ **Vérifier les permissions fichiers**  
⚠️ **Tester après chaque modification**

---

## 📱 Contacts et Informations

**Site installé** : S2MC Consulting  
**Type** : Site vitrine monopage (SPA)  
**Framework** : React 19  
**Design** : Tailwind CSS + shadcn/ui  
**Serveurs supportés** : Apache, Nginx  

---

**Vous êtes prêt à installer votre site S2MC Consulting ! 🚀**

Choisissez le guide qui correspond à votre situation et suivez les instructions.
