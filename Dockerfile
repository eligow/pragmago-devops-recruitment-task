# Dockerfile
FROM php:8.1-alpine

RUN apk add --no-cache linux-headers autoconf openssl-dev g++ make pcre-dev icu-dev zlib-dev libzip-dev libpq-dev && \
    docker-php-ext-install bcmath intl opcache zip sockets pdo_pgsql && \
    apk del --purge autoconf g++ make

WORKDIR /usr/src/app

COPY --from=composer:2.8.6 /usr/bin/composer /usr/bin/composer

COPY composer.json composer.lock ./

RUN composer update

RUN ./vendor/bin/rr get-binary --location /usr/local/bin

COPY . .

RUN composer dump-autoload --optimize && \
    composer check-platform-reqs && \
    php bin/console cache:warmup

EXPOSE 8080

CMD ["rr", "serve"]
