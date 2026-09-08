FROM wordpress:cli-2.12.0-php8.5 AS wp-cli

FROM wordpress:7.1.0-php8.5-apache

ARG PHPREDIS_VERSION=6.3.0

RUN set -eux; \
    pecl install "redis-${PHPREDIS_VERSION}"; \
    docker-php-ext-enable redis; \
    php -m | grep -Fx redis; \
    rm -rf /tmp/pear

RUN set -eux; \
    sed -ri 's/^Listen 80$/Listen 8080/' /etc/apache2/ports.conf; \
    sed -ri 's/<VirtualHost \*:80>/<VirtualHost *:8080>/' /etc/apache2/sites-available/000-default.conf; \
    grep -Fx 'Listen 8080' /etc/apache2/ports.conf; \
    grep -Fx '<VirtualHost *:8080>' /etc/apache2/sites-available/000-default.conf; \
    apache2ctl -t

COPY wordpress.ini $PHP_INI_DIR/conf.d/wordpress.ini
COPY healthz.html /usr/src/wordpress/healthz.html
COPY --from=wp-cli /usr/local/bin/wp /usr/local/bin/wp
COPY mu-plugins/hack4good-smtp.php /usr/src/wordpress/wp-content/mu-plugins/hack4good-smtp.php
COPY docker-entrypoint-hack4good.sh /usr/local/bin/

EXPOSE 8080

ENTRYPOINT ["docker-entrypoint-hack4good.sh"]
CMD ["apache2-foreground"]
