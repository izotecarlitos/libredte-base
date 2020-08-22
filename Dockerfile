FROM php:7.3-apache

RUN apt-get update 

RUN apt-get install -y \
    git wget mercurial nano apt-transport-https lsb-release \
    libcurl4-gnutls-dev libpng-dev libjpeg-dev libssl-dev \
    libc-client-dev libkrb5-dev libghc-postgresql-libpq-dev \
    libxml2-dev libmcrypt-dev libpq-dev zlib1g-dev libzip-dev 

RUN pecl install mcrypt-1.0.3 

RUN docker-php-ext-configure gd --with-jpeg-dir=/usr/lib \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure imap --with-imap-ssl --with-kerberos \
    && docker-php-ext-install -j$(nproc) imap \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/include/postgresql \
    && docker-php-ext-install -j$(nproc) pgsql \
    && docker-php-ext-enable mcrypt \
    && docker-php-ext-install -j$(nproc) pdo pdo_pgsql curl soap zip 

RUN pear install Mail Mail_mime Net_SMTP 
    
RUN a2enmod rewrite ssl php7 && service apache2 restart
