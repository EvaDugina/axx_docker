FROM php:8.3-fpm

RUN apt-get update && apt-get install -y \
    docker.io \
    libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql pgsql \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN sed -i "s/^user = www-data/user = root/" /usr/local/etc/php-fpm.d/www.conf && \
    sed -i "s/^group = www-data/group = root/" /usr/local/etc/php-fpm.d/www.conf

# COPY ./for_docker/php/www.conf /usr/local/etc/php-fpm.d/www.conf

COPY ./for_docker/php/php.ini /usr/local/etc/php

RUN mkdir -p /var/lib/php/sessions && chmod 777 /var/lib/php/sessions

RUN chmod 1777 /tmp

# RUN usermod -aG docker www-data

# RUN chown -R www-data:www-data /var/www/html

CMD ["php-fpm", "-R"]