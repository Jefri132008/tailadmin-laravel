FROM ubuntu:22.04

# Gunakan ENV agar tidak error 'unknown instruction'
ENV DEBIAN_FRONTEND=noninteractive

# Pastikan instalasi curl dan nodejs v18 ada di sini (untuk mendukung vue-i18n)
RUN apt update -y && apt install -y curl
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -

RUN apt update -y && apt install -y \
    apache2 \
    php \
    nodejs \
    php-xml \
    php-mbstring \
    php-curl \
    php-mysql \
    php-gd \
    unzip \
    nano \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sS https://getcomposer.org/installer -o composer-setup.php && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer

RUN mkdir -p /var/www/sosmed
WORKDIR /var/www/sosmed

ADD . /var/www/sosmed
ADD sosmed.conf /etc/apache2/sites-available/

RUN a2dissite 000-default.conf && a2ensite sosmed.conf

# Jalankan install.sh dengan bash -x untuk debug jika ada error lagi
RUN chmod +x install.sh && bash -x ./install.sh

RUN chown -R www-data:www-data /var/www/sosmed && \
    chmod -R 755 /var/www/sosmed

EXPOSE 8090
CMD php artisan serve --host=0.0.0.0 --port=8090
