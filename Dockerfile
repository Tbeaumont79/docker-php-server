FROM php:8.3-apache

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN apt-get update -qq && \
    apt-get install -qy \
    git \
    gnupg \
    unzip \
    zip && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# PHP Extensions
RUN docker-php-ext-install -j$(nproc) opcache pdo_mysql


COPY conf/php.ini /usr/local/etc/php/conf.d/app.ini

# Apache

COPY conf/vhost.conf /etc/apache2/sites-available/000-default.conf
COPY conf/httpd.conf /etc/apache2/conf-available/z-app.conf
COPY ./src /var/www/html
RUN sleep 5
RUN a2ensite /etc/apache2/sites-available/000-default.conf
RUN sleep 5
RUN a2enmod rewrite 
RUN  service apache2 restart