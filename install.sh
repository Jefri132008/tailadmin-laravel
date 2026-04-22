#!/bin/bash

npm install
composer install --prefer-dist --no-scripts --no-dev --optimize-autoloader
cp .env.example .env
php artisan key:generate
php artisan migrate --seed
php artisan storage:link
