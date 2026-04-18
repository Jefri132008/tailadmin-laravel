#!/bin/sh
set -e

# Buat folder yang diperlukan
mkdir -p bootstrap/cache \
         storage/framework/cache \
         storage/framework/sessions \
         storage/framework/views

# Set permission
chown -R www-data:www-data bootstrap storage || true
chmod -R ug+rwx bootstrap storage || true

# Install dependencies (Ganti dev jadi build)
npm install --legacy-peer-deps --no-audit --progress=false
npm run build 

composer install --optimize-autoloader --no-interaction

# Setup env
cp .env.example .env || true
php artisan key:generate

# Update config env
sed -i 's/DB_HOST=127.0.0.1/DB_HOST=mysql/g' .env
sed -i 's/DB_PASSWORD=/DB_PASSWORD=password/g' .env

# JANGAN masukan php artisan migrate di sini.
