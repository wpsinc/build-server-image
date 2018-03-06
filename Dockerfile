FROM php:7.1.12-cli

MAINTAINER "Austin Maddox" <amaddox@wps-inc.com>

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
    zip

# Install Node.js.
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - \
    && apt-get install -y \
    nodejs

# Install AWS CLI.
RUN apt-get install -y \
    groff \
    python \
    && curl -O https://bootstrap.pypa.io/get-pip.py \
    && python get-pip.py --user \
    && rm get-pip.py \
    && python ~/.local/lib/python2.7/site-packages/pip install awscli --upgrade

# Install GD library.
RUN apt-get install -y \
    libpng12-dev \
    libjpeg-dev \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install gd

# Install PHP extensions.
RUN docker-php-ext-install \
    bcmath \
    mbstring \
    pdo_mysql \
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
