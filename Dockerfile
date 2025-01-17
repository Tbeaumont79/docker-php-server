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

COPY conf/vhost.conf /etc/apache2/sites-available/vhost.conf
COPY ./app /var/www/app


RUN a2ensite vhost.conf && \
    a2dissite 000-default.conf && \
    a2enmod rewrite


EXPOSE 80

CMD ["apache2-foreground"]

