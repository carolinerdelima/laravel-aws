# Use a imagem PHP-FPM como base
FROM php:8.1.2-fpm

# Atualize os pacotes e instale as dependências necessárias
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

# Configure a extensão GD
RUN docker-php-ext-configure gd --with-freetype --with-webp --with-jpeg
RUN docker-php-ext-install gd pdo_mysql zip bcmath mbstring

# Instale o Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Configurações adicionais do PHP
COPY php.ini /usr/local/etc/php/conf.d/php.ini

# Instalando o Supervisor para gerenciar os workers Laravel
RUN apt-get install -y supervisor

# Copiando o arquivo de configuração do worker do Laravel
COPY laravel-worker.conf /etc/supervisor/conf.d/laravel-worker.conf

# Copiando a configuração do Nginx
COPY laravel.conf /etc/nginx/conf.d/default.conf

# Copia os scripts de inicialização
COPY startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

# Expôe a porta 80 para o Nginx
EXPOSE 80

# Define o comando de inicialização padrão
CMD ["/usr/local/bin/startup.sh"]