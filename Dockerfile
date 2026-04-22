FROM php:8.1-fpm

RUN apt-get update && apt-get install -y \
    curl \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libicu-dev \
    zip \
    unzip \
    git \
    && curl -sL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd intl zip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app

COPY . . 

RUN chmod +x install.sh && bash ./install.sh
RUN chown -R www-data:www-data /app/storage /app/bootstrap/cache

EXPOSE 8090

CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8090"]npm
