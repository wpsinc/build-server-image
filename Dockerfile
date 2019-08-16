FROM php:7.3-buster

MAINTAINER "WPS" <web_services@wps-inc.com>

RUN printf "deb http://deb.debian.org/debian buster main\n deb-src http://deb.debian.org/debian buster main\n deb http://deb.debian.org/debian-security/ buster/updates main\ndeb-src http://deb.debian.org/debian-security/ buster/updates main\n deb http://deb.debian.org/debian buster-updates main\n deb-src http://deb.debian.org/debian buster-updates main" > /etc/apt/sources.list

RUN apt-get update

# Install required tools (https://circleci.com/docs/2.0/custom-images/#adding-required-and-custom-tools-or-files)
RUN apt-get install -y \
    ca-certificates \
    curl \
    git \
    gzip \
    sqlite3 \
    ssh \
    tar \
    libpq-dev \
    libzip-dev \
    awscli \
    npm

# Install GD library.
RUN apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install gd

# Install PHP extensions.
RUN docker-php-ext-install \
    bcmath \
    mbstring \
    pdo_mysql \
    pgsql \
    pdo_pgsql \
    mysqli \
    zip

# Install Composer executable.
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"

# Install Docker Compose
RUN curl -L https://github.com/docker/compose/releases/download/1.17.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

# Cleanup
RUN apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
