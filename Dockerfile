FROM nginx/unit:1.26.1-php8.1

EXPOSE 8080

COPY ./nginx-config.json ./docker-entrypoint.d/config.json

RUN apt update &&      \
    apt install git libzip-dev -y 

RUN set -xe &&				     \
    export DEBIAN_FRONTEND=noninteractive && \
    docker-php-ext-install xdebug zip pdo_mysql

ADD https://getcomposer.org/installer /tmp/composer
RUN php /tmp/composer --install-dir=/usr/bin --filename=composer
