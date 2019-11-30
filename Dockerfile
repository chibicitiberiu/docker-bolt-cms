FROM php:7.1-apache
MAINTAINER Tiberiu Chibici "chibicitiberiu@gmail.com"

# PHP modules
RUN apt-get update && \
    apt-get install -y git \
                       wget \
                       curl \
                       libpng-dev \
                       libjpeg62-turbo-dev \
                       libfreetype6-dev \
                       zlib1g-dev \
                       libicu-dev \
                       libxrender1 \
                       libfontconfig1 \
                       libsqlite3-dev \
                       sqlite3 \
                       libpq-dev

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
		docker-php-ext-install gd && \
        docker-php-ext-configure intl && \
        docker-php-ext-install intl && \
        docker-php-ext-install pdo && \
        docker-php-ext-install pdo_sqlite && \
        docker-php-ext-install pdo_mysql && \
        docker-php-ext-install pdo_pgsql && \
        docker-php-ext-install exif && \
        docker-php-ext-install zip && \
        docker-php-ext-install opcache && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*

# Apache modules
RUN a2enmod headers
RUN a2enmod rewrite

# Install bolt
RUN mkdir -p /var/www/html/
WORKDIR /var/www/html/

VOLUME ./app/cache \
    ./app/config \
    ./app/database \
    ./public/extensions \
    ./public/files \
    ./extensions

ARG BOLT_URL=https://bolt.cm/distribution/bolt-latest.tar.gz

RUN curl -sS $BOLT_URL | tar -xvz --strip-components=1
RUN mv .bolt.yml.dist .bolt.yml && \
    mv composer.json.dist composer.json && \
    mv composer.lock.dist composer.lock && \
    mv src/Site/CustomisationExtension.php.dist src/Site/CustomisationExtension.php

# Set up config
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS="0" \
    PHP_OPCACHE_MAX_ACCELERATED_FILES="10000" \
    PHP_OPCACHE_MEMORY_CONSUMPTION="192" \
    PHP_OPCACHE_MAX_WASTED_PERCENTAGE="10"

COPY config/default.htaccess .htaccess
COPY config/apache-vhost.conf /etc/apache2/sites-available/000-default.conf
COPY config/php.ini /usr/local/etc/php/conf.d/php-config.ini
COPY config/opcache.ini /usr/local/etc/php/conf.d/opcache.ini
RUN touch app/config/config.yml

# Set up initialization script
COPY init.sh .
RUN chmod +x init.sh

ENTRYPOINT /var/www/html/init.sh
