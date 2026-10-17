FROM debian:bookworm

RUN apt-get update && apt-get install -y php-fpm php-mysql -y \
    mariadb-client \
    wget \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/php
RUN chown -R www-data:www-data /run/php

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

COPY tools/setup.sh /usr/local/bin/setup.sh

RUN chmod +x /usr/local/bin/setup.sh


ENTRYPOINT ["/usr/local/bin/setup.sh"]