FROM php:8.1-cli

RUN apt-get update \
 && apt-get install git zip libzip-dev libgmp-dev libevent-dev libnghttp2-dev libffi-dev libssl-dev -y \
 && rm -r /var/lib/apt/lists/* \
 && rm -r /var/cache/*

RUN mkdir -p /usr/src/php/ext/ && cd /usr/src/php/ext/ \
 && pecl bundle ev \
 && pecl bundle openswoole \
 && docker-php-ext-configure openswoole --enable-openssl=yes --enable-http2 \
 && docker-php-ext-configure opcache --enable-opcache \
 && docker-php-ext-install -j$(nproc) sockets zip gmp pcntl bcmath ffi mysqli pdo pdo_mysql openswoole ev opcache \
 && docker-php-source delete \
 && rm -rf /usr/src/*

RUN git clone --depth 1 https://github.com/danog/PrimeModule-ext /usr/src/PrimeModule-ext \
 && cd /usr/src/PrimeModule-ext && make -j$(nproc) \
 && make install \
 && rm -rf /usr/src/* \
 && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN git clone --depth 1 https://github.com/xtrime-ru/TelegramApiServer /opt/TelegramApiServer \
 && cd /opt/TelegramApiServer \
 && composer install -o --no-dev \
 && git clone --depth 1 https://github.com/xtrime-ru/TelegramRSS /opt/TelegramRSS \
 && cd /opt/TelegramRSS \
 && composer install -o --no-dev

COPY conf.d/. "$PHP_INI_DIR/conf.d/"
COPY entrypoint.sh /entrypoint.sh

EXPOSE 9503
EXPOSE 9504

STOPSIGNAL SIGQUIT
ENTRYPOINT ["/entrypoint.sh"]