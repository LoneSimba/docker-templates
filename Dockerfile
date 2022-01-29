FROM nginx/unit:1.26.1-php8.1

EXPOSE 8080

COPY ./nginx-config.json ./docker-entrypoint.d/config.json
RUN echo '<?php echo "Hello, PHP on Unit!"; ?>' > /var/www/index.php

RUN set -xe                                                                                                         \
    && export DEBIAN_FRONTEND=noninteractive                                                                        \
    && apt update                                                                                                   \
    && apt install apt-transport-https lsb-release ca-certificates curl -y                                          \
    && wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg                                 \
    && sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'

RUN apt update                                  \
    && export DEBIAN_FRONTEND=noninteractive    \
    && apt install php8.1-intl php8.1-xdebug -y

ADD https://getcomposer.org/installer /tmp/composer
RUN php /tmp/composer --install-dir=/usr/bin --filename=composer \
    && sy -s /bin/bash www-data -c

RUN kill 'pidof unitd' && cat /var/log/unit.log

CMD ["unitd", "--no-daemon", "--control", "unix:/var/run/control.unit.sock"]