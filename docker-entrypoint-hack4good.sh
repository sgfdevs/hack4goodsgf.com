#!/bin/sh
set -eu

mkdir -p /var/www/html/wp-content/mu-plugins
cp /usr/src/wordpress/wp-content/mu-plugins/hack4good-smtp.php /var/www/html/wp-content/mu-plugins/hack4good-smtp.php

exec docker-entrypoint.sh "$@"
