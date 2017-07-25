FROM php:7.1.7-cli

MAINTAINER "Austin Maddox" <amaddox@wps-inc.com>

RUN apt-get update

# Install required tools (https://circleci.com/docs/2.0/custom-images/#adding-required-and-custom-tools-or-files)
RUN apt-get install -y \
    ca-certificates \
    git \
    gzip \
    ssh \
    tar \
    zip

# Install PHP extensions.
RUN docker-php-ext-install \
    bcmath \
    mbstring \
    pdo_mysql

# Install Composer executable.
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"

# Install Docker Compose
RUN curl -L https://github.com/docker/compose/releases/download/1.14.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

# Cleanup
RUN apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
