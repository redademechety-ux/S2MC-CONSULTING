#!/bin/bash

# Script de correction rapide pour supprimer la configuration défectueuse

echo "Nettoyage de la configuration Nginx défectueuse..."

# Supprimer les configurations
sudo rm -f /etc/nginx/sites-enabled/s2mc-consulting.com
sudo rm -f /etc/nginx/sites-available/s2mc-consulting.com

# Tester la configuration
sudo nginx -t

echo "Configuration nettoyée. Vous pouvez maintenant relancer:"
echo "  sudo ./install-nginx.sh"
