FROM nginx/unit:1.26.1-php8.1

EXPOSE 8080

COPY ./nginx-config.json ./docker-entrypoint.d/config.json
RUN echo '<?php phpinfo(); ?>' > /var/www/index.php

RUN set -xe                                  \
    && export DEBIAN_FRONTEND=noninteractive \
    && pecl install xdebug-3.1.2             \
    && docker-php-ext-enable xdebug

ADD https://getcomposer.org/installer /tmp/composer
RUN php /tmp/composer --install-dir=/usr/bin --filename=composer \
    && sy -s /bin/bash www-data -c

RUN kill 'pidof unitd' && cat /var/log/unit.log

CMD ["unitd", "--no-daemon", "--control", "unix:/var/run/control.unit.sock"]