#!/bin/sh
set -eu

if [ "${1:-}" = apache2-foreground ]; then
  case "${APACHE_MAX_REQUEST_WORKERS:-}" in
    ''|*[!0-9]*)
      echo 'APACHE_MAX_REQUEST_WORKERS must be an integer between 2 and 256' >&2
      exit 1
      ;;
  esac
  if [ "$APACHE_MAX_REQUEST_WORKERS" -lt 2 ] || [ "$APACHE_MAX_REQUEST_WORKERS" -gt 256 ]; then
    echo 'APACHE_MAX_REQUEST_WORKERS must be an integer between 2 and 256' >&2
    exit 1
  fi
fi

mkdir -p /var/www/html/wp-content/mu-plugins
cp /usr/src/wordpress/wp-content/mu-plugins/hack4good-smtp.php /var/www/html/wp-content/mu-plugins/hack4good-smtp.php

exec docker-entrypoint.sh "$@"
