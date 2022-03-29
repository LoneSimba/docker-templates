FROM nginx/unit:1.26.1-php8.1

EXPOSE 8080
ARG ENV=development

COPY ./php.ini-${ENV} /usr/local/etc/php/php.ini
COPY ./nginx-config.json ./docker-entrypoint.d/config.json

RUN set -xe && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

RUN apt update && \
    apt install nano git libzip-dev libicu-dev -y

RUN set -xe && \
    export DEBIAN_FRONTEND=noninteractive && \
    docker-php-ext-install zip pdo_mysql intl 

RUN if test "$ENV" = "development"; then \
        pecl install xdebug-3.1.2 && \
        docker-php-ext-enable xdebug && \
        echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
        echo "xdebug.client_host = host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
        echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini;\
    fi 

ADD https://getcomposer.org/installer /tmp/composer
RUN php /tmp/composer --install-dir=/usr/bin --filename=composer

