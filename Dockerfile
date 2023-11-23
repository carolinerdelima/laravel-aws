FROM php:8.1.2-fpm

# Atualizando os pacotes e instalando as dependências necessárias
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libzip-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev

# Configurando a extensão GD
RUN docker-php-ext-configure gd --with-freetype --with-webp --with-jpeg
RUN docker-php-ext-install gd pdo_mysql zip bcmath mbstring

# Instalando o Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copiando as configurações específicas do PHP
COPY php.ini /usr/local/etc/php/conf.d/php.ini

# Expondo a porta 80 para o Nginx
EXPOSE 80

# Definindo o comando de inicialização padrão
CMD ["/usr/local/bin/startup.sh"]