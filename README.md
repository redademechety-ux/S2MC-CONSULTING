# S2MC Consulting Website

🌐 **Professional showcase website for S2MC Consulting**

Strategy, Management, and Marketing Consulting

[![Deployed on Nginx](https://img.shields.io/badge/Deployed-Nginx-green)](https://s2mc-consulting.com)
[![React](https://img.shields.io/badge/React-19-blue)](https://reactjs.org/)
[![TailwindCSS](https://img.shields.io/badge/TailwindCSS-3.4-38B2AC)](https://tailwindcss.com/)

---

## 🚀 Features

- ✨ Modern and professional design
- 📱 Fully responsive (mobile, tablet, desktop)
- ⚡ Optimized performance with lazy loading
- 🎨 Beautiful UI with Tailwind CSS + shadcn/ui
- 🔒 Secure and SEO optimized
- 💼 Single-page application with smooth navigation
- 📊 Contact information display
- 🌐 Multi-browser compatible

---

## 🛠️ Tech Stack

- **Frontend**: React 19
- **Styling**: Tailwind CSS + shadcn/ui components
- **Build Tool**: Yarn + Create React App
- **Web Server**: Nginx (optimized configuration)
- **SSL**: Let's Encrypt (automated setup)

---

## 📦 Quick Start

### For Local Development

```bash
# Clone the repository
git clone https://github.com/redademechety-ux/S2MC-CONSULTING.git
cd S2MC-CONSULTING/frontend

# Install dependencies
yarn install

# Start development server
yarn start

# Open http://localhost:3000
```

### Build for Production

```bash
cd frontend
yarn build

# Build output will be in frontend/build/
```

---

## 🚀 Deployment

### Automatic Installation on Linux Server (Nginx)

```bash
# Clone the repository
git clone https://github.com/redademechety-ux/S2MC-CONSULTING.git
cd S2MC-CONSULTING/deployment

# Make scripts executable
chmod +x install-nginx.sh

# Run installation (requires sudo)
sudo ./install-nginx.sh
```

The script will:
- ✅ Install Node.js and Yarn
- ✅ Install and configure Nginx
- ✅ Build the application
- ✅ Configure SSL with Let's Encrypt (optional)
- ✅ Set up firewall rules
- ✅ Configure automatic caching and compression

### Update Deployed Site

```bash
cd S2MC-CONSULTING/deployment
sudo ./update-nginx.sh
```

---

## 📁 Project Structure

```
S2MC-CONSULTING/
├── frontend/                   # React application
│   ├── src/
│   │   ├── components/        # React components
│   │   │   ├── Header.js
│   │   │   ├── Hero.js
│   │   │   ├── Services.js
│   │   │   ├── About.js
│   │   │   ├── Contact.js
│   │   │   └── Footer.js
│   │   ├── styles/           # CSS files
│   │   ├── App.js            # Main app component
│   │   ├── App.css           # Design system
│   │   └── index.js
│   ├── public/               # Static assets
│   ├── package.json
│   └── tailwind.config.js
│
├── deployment/               # Deployment scripts
│   ├── install-nginx.sh     # Automated Nginx installation
│   ├── update-nginx.sh      # Update script
│   ├── build.sh             # Local build script
│   ├── LISEZ-MOI.txt        # French quick guide
│   ├── README.md            # Deployment documentation
│   ├── QUICK_START.md       # Quick installation guide
│   └── SCENARIOS-HEBERGEMENT.md  # Hosting scenarios
│
├── .gitignore
├── README.md                # This file
└── DEPLOY_TO_GITHUB.md     # GitHub deployment guide
```

---

## 🎨 Design System

The website follows the **Pixel Pushers design system** with:

### Colors
- **Background**: `#1a1c1b` (Dark black)
- **Primary**: `#d9fb06` (Lime green)
- **Text**: Lime green on dark backgrounds
- **Cards**: `#302f2c` (Dark gray)

### Typography
- **Headings**: PP Right Grotesk (fallback: Arial), uppercase, bold
- **Body**: Inter (fallback: Arial), medium weight
- **Scale**: Responsive with clamp()

### Components
- Pill-shaped buttons with hover effects
- Card components with hover transitions
- Fixed header with smooth scroll
- Mobile-responsive navigation

---

## 📚 Documentation

### For Deployment

| File | Description | Language |
|------|-------------|----------|
| `deployment/LISEZ-MOI.txt` | Quick start guide | 🇫🇷 French |
| `deployment/README.md` | Complete technical documentation | 🇬🇧 English |
| `deployment/QUICK_START.md` | 3-step installation guide | 🇬🇧 English |
| `deployment/SCENARIOS-HEBERGEMENT.md` | Hosting scenarios (shared, VPS, Docker, K8s) | 🇫🇷 French |
| `DEPLOY_TO_GITHUB.md` | GitHub deployment instructions | 🇫🇷 French |

---

## 🌐 Live Website

**Domain**: s2mc-consulting.com  
**Hosted on**: Nginx Linux Server

### Site Sections

1. **Hero Section** - Company introduction with CTA
2. **Services** - Three main consulting services
3. **About** - Company values and mission
4. **Contact** - Address, email, business hours
5. **Footer** - Copyright and company info

---

## 🔧 Configuration

### Nginx Configuration

Optimized configuration included with:
- GZIP compression
- Browser caching
- Security headers
- React Router support (SPA)
- SSL/TLS configuration

See `deployment/nginx-multisite.conf.example`

### Environment Variables

No environment variables required for the frontend showcase site.

---

## 🧪 Testing

```bash
# Run development server
cd frontend
yarn start

# Test production build locally
yarn build
npx serve -s build
```

---

## 📞 Contact Information

**S2MC Consulting**

- 📍 **Address**: 1021 E Lincolnway Unit #1375, Cheyenne, WY 82001, United States
- 📧 **Email**: s2mc.company@gmail.com
- 🕒 **Business Hours**: Monday - Friday, 9:00 AM - 5:00 PM (MST)

---

## 🤝 Contributing

This is a private company website. For any updates or modifications, please contact the development team.

---

## 📄 License

All rights reserved © 2025 S2MC Consulting

---

## 🆘 Support

### For Deployment Issues

1. Check Nginx logs: `sudo tail -f /var/log/nginx/S2MC-consulting.com-error.log`
2. Verify permissions: `ls -la /var/www/S2MC-consulting`
3. Test Nginx config: `sudo nginx -t`
4. Restart Nginx: `sudo systemctl restart nginx`

### For Development Issues

1. Clear node_modules: `rm -rf node_modules && yarn install`
2. Clear build cache: `rm -rf build`
3. Check React scripts: `yarn start --verbose`

---

## 🔄 Version History

- **v1.0.0** (2025) - Initial release
  - Single-page showcase website
  - Responsive design
  - Nginx deployment scripts
  - Complete documentation

---

**Built with ❤️ for S2MC Consulting**

---

## 🚀 Quick Commands

```bash
# Development
yarn start          # Start dev server
yarn build          # Build for production

# Deployment
sudo ./deployment/install-nginx.sh    # Install on server
sudo ./deployment/update-nginx.sh     # Update site

# Git
git pull origin main                  # Get latest changes
git push origin main                  # Push changes
```
