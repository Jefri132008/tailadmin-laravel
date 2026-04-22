FROM php:8.1-fpm

RUN apt-get update && apt-get install -y \
	libpng-dev \
	libjpeg-dev \
	libfreetype6-dev \
	locales \
	zip \
	jpegoptim optipng pngquant gifsicle \
	vim \
	unzip \
	git \
	curl \
	libonig-dev \
	libxml2-dev \
	libzip-dev \
	libicu-dev \
	g++ \
	nodejs \
	npm

RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd intl zip

WORKDIR /app

COPY . .

RUN chmod +x install.sh
RUN ./install.sh

CMD php artisan serve --host=0.0.0.0 --port=8090

EXPOSE 8090
