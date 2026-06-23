#!/bin/bash

# Digital Movie Poster - Update Script
# Updated for Raspberry Pi OS Bookworm, PHP 8.2, Node 20

echo -e "\n\nPulling latest code\n"
cd /var/www/html
git pull origin main

echo -e "\n\nUpdating Composer dependencies\n"
composer install --no-interaction --optimize-autoloader

echo -e "\n\nUpdating Node dependencies\n"
npm install

echo -e "\n\nBuilding frontend assets\n"
npm run build

echo -e "\n\nRunning database migrations\n"
php artisan migrate --force

echo -e "\n\nClearing and re-caching config\n"
php artisan optimize:clear
php artisan optimize

echo -e "\n\nRestarting queue workers\n"
supervisorctl restart laravel-worker:*

echo -e "\n\nRestarting socket server\n"
cd /var/www/html/socketserver
pm2 restart server

echo -e "\n\nUpdate complete!\n"
