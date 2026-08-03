FROM wordpress:cli-2.12.0-php8.5 AS wp-cli

FROM wordpress:7.0.2-php8.5-apache

ARG PHPREDIS_VERSION=6.3.0

RUN set -eux; \
    pecl install "redis-${PHPREDIS_VERSION}"; \
    docker-php-ext-enable redis; \
    php -m | grep -Fx redis; \
    rm -rf /tmp/pear

COPY wordpress.ini $PHP_INI_DIR/conf.d/wordpress.ini
COPY healthz.html /usr/src/wordpress/healthz.html
COPY --from=wp-cli /usr/local/bin/wp /usr/local/bin/wp
COPY mu-plugins/hack4good-smtp.php /usr/src/wordpress/wp-content/mu-plugins/hack4good-smtp.php
COPY docker-entrypoint-hack4good.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint-hack4good.sh"]
CMD ["apache2-foreground"]
