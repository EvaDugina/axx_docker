FROM postgres:14 as pgclient
FROM php:8.3-fpm

RUN apt-get update && apt-get install -y \
    docker.io \
    libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql pgsql \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Для отладки (XDEBUG)
# RUN pecl install xdebug && docker-php-ext-enable xdebug
# COPY ./for_docker/php/xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN sed -i "s/^user = www-data/user = root/" /usr/local/etc/php-fpm.d/www.conf && \
    sed -i "s/^group = www-data/group = root/" /usr/local/etc/php-fpm.d/www.conf

# COPY ./for_docker/php/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./for_docker/php/php.ini /usr/local/etc/php

RUN mkdir -p /var/lib/php/sessions && chmod 777 /var/lib/php/sessions

RUN chmod 1777 /tmp

# RUN usermod -aG docker www-data

# RUN chown -R www-data:www-data /var/www/html

# Для создания бэкапов
COPY --from=pgclient /usr/lib/postgresql/14/bin/pg_dump /usr/bin/pg_dump
COPY ./for_docker/psql/make_backup.sh /make_backup.sh
RUN apt-get update && apt install dos2unix && dos2unix /make_backup.sh
RUN chmod +x /make_backup.sh

CMD ["php-fpm", "-R"]