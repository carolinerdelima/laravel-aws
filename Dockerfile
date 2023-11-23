FROM php:8.1.2-fpm

RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \ 
    libzip-dev

# Instala o Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN docker-php-ext-install pdo_mysql zip bcmath mbstring

WORKDIR /app
COPY composer.json .
RUN composer install --no-scripts
COPY . .    

CMD php artisan serve --host=0.0.0.0 --port 80