# 🚀 Déployer S2MC Consulting sur GitHub

## Configuration Initiale

Votre dépôt GitHub : **https://github.com/redademechety-ux/S2MC-CONSULTING**

---

## 📋 Étape 1 : Préparer le Projet

Le projet est déjà prêt avec :
- ✅ `.gitignore` configuré
- ✅ Structure de fichiers propre
- ✅ Documentation complète
- ✅ Scripts d'installation

---

## 🔧 Étape 2 : Initialiser Git et Pousser vers GitHub

### Sur votre machine (dans /app)

```bash
# 1. Initialiser le dépôt Git
cd /app
git init

# 2. Ajouter tous les fichiers
git add .

# 3. Premier commit
git commit -m "Initial commit: S2MC Consulting website with deployment scripts"

# 4. Ajouter le remote GitHub
git remote add origin https://github.com/redademechety-ux/S2MC-CONSULTING.git

# 5. Créer la branche main et pousser
git branch -M main
git push -u origin main
```

### Si vous avez des problèmes d'authentification GitHub

**Option 1 : Utiliser un Token Personnel (Recommandé)**

1. Aller sur GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Générer un nouveau token avec les permissions `repo`
3. Utiliser le token comme mot de passe lors du push

**Option 2 : Utiliser SSH**

```bash
# Générer une clé SSH
ssh-keygen -t ed25519 -C "votre-email@example.com"

# Afficher la clé publique
cat ~/.ssh/id_ed25519.pub

# Copier la clé et l'ajouter sur GitHub → Settings → SSH keys

# Changer le remote en SSH
git remote set-url origin git@github.com:redademechety-ux/S2MC-CONSULTING.git

# Pousser
git push -u origin main
```

---

## 📁 Structure du Projet sur GitHub

```
S2MC-CONSULTING/
├── .gitignore                  # Fichiers à ignorer
├── README.md                   # Documentation principale (à créer)
├── DEPLOY_TO_GITHUB.md        # Ce fichier
│
├── frontend/                   # Application React
│   ├── src/
│   │   ├── components/        # Composants React
│   │   ├── styles/           # Fichiers CSS
│   │   ├── App.js
│   │   └── index.js
│   ├── public/
│   ├── package.json
│   └── tailwind.config.js
│
├── backend/                    # Backend FastAPI (optionnel)
│   ├── server.py
│   └── requirements.txt
│
└── deployment/                 # Scripts d'installation
    ├── LISEZ-MOI.txt
    ├── INDEX.md
    ├── README.md
    ├── QUICK_START.md
    ├── SCENARIOS-HEBERGEMENT.md
    ├── install-nginx.sh        # Installation Nginx
    ├── update-nginx.sh         # Mise à jour
    ├── build.sh
    ├── create-package.sh
    └── nginx-multisite.conf.example
```

---

## 📝 Créer un README.md Principal

Créez un fichier `/app/README.md` :

```markdown
# S2MC Consulting Website

🌐 **Site vitrine professionnel pour S2MC Consulting**

Strategy, Management, and Marketing Consulting

## 🚀 Caractéristiques

- ✨ Design moderne et professionnel
- 📱 Entièrement responsive
- ⚡ Performance optimisée
- 🎨 Interface utilisateur élégante
- 🔒 Sécurisé et optimisé SEO

## 🛠️ Technologies

- **Frontend**: React 19
- **Styling**: Tailwind CSS + shadcn/ui
- **Serveur**: Nginx
- **Build**: Yarn

## 📦 Installation

### Installation Automatique sur Serveur Linux

```bash
# Cloner le dépôt
git clone https://github.com/redademechety-ux/S2MC-CONSULTING.git
cd S2MC-CONSULTING

# Exécuter l'installation
cd deployment
chmod +x install-nginx.sh
sudo ./install-nginx.sh
```

### Installation Locale pour Développement

```bash
# Installer les dépendances
cd frontend
yarn install

# Lancer en mode développement
yarn start

# Build pour production
yarn build
```

## 📚 Documentation

Consultez le dossier `deployment/` pour :
- Guide d'installation complet
- Configuration Nginx
- Scripts de déploiement
- Scénarios d'hébergement

## 🌐 Déploiement

Domaine : **S2MC-consulting.com**

Pour déployer sur votre serveur, consultez :
- `deployment/LISEZ-MOI.txt` - Guide en français
- `deployment/README.md` - Documentation complète
- `deployment/QUICK_START.md` - Installation rapide

## 📞 Contact

**S2MC Consulting**
- 📍 1021 E Lincolnway Unit #1375, Cheyenne, WY 82001
- 📧 s2mc.company@gmail.com

## 📄 Licence

Tous droits réservés © 2025 S2MC Consulting
```

---

## 🔄 Workflow de Développement

### Après avoir fait des modifications

```bash
# 1. Vérifier les changements
git status

# 2. Ajouter les fichiers modifiés
git add .

# 3. Commit avec un message descriptif
git commit -m "Description des modifications"

# 4. Pousser vers GitHub
git push origin main
```

### Créer des branches pour les fonctionnalités

```bash
# Créer une nouvelle branche
git checkout -b feature/nouvelle-fonctionnalite

# Travailler et commiter
git add .
git commit -m "Ajout de la nouvelle fonctionnalité"

# Pousser la branche
git push origin feature/nouvelle-fonctionnalite

# Créer une Pull Request sur GitHub
# Puis merger dans main
```

---

## 📦 Déploiement depuis GitHub

### Sur votre serveur de production

```bash
# 1. Cloner le dépôt
git clone https://github.com/redademechety-ux/S2MC-CONSULTING.git /tmp/s2mc

# 2. Exécuter l'installation
cd /tmp/s2mc/deployment
chmod +x install-nginx.sh
sudo ./install-nginx.sh
```

### Mise à jour depuis GitHub

```bash
# Sur le serveur
cd /tmp/s2mc
git pull origin main
cd deployment
sudo ./update-nginx.sh
```

---

## 🔐 Sécurité

**Fichiers exclus de Git (via .gitignore)** :
- ❌ `node_modules/`
- ❌ `.env` (variables d'environnement)
- ❌ `build/` (fichiers buildés)
- ❌ Logs et fichiers temporaires

**À ne JAMAIS commiter** :
- Clés API
- Mots de passe
- Certificats SSL
- Fichiers de configuration avec données sensibles

---

## 🎯 Prochaines Étapes

1. ✅ Pousser le code sur GitHub
2. ✅ Créer un README.md principal
3. ✅ Ajouter une licence si nécessaire
4. ✅ Configurer GitHub Pages (optionnel)
5. ✅ Ajouter des GitHub Actions pour CI/CD (optionnel)

---

## 💡 Conseils

- Faites des commits fréquents avec des messages clairs
- Utilisez des branches pour les nouvelles fonctionnalités
- Documentez vos changements
- Testez avant de pousser sur main
- Gardez votre .gitignore à jour

---

## 🆘 Aide

Si vous rencontrez des problèmes :

1. Vérifiez que Git est installé : `git --version`
2. Vérifiez votre configuration : `git config --list`
3. Consultez les logs : `git log`
4. Documentation Git : https://git-scm.com/doc

---

**Votre projet est maintenant prêt pour GitHub ! 🎉**
