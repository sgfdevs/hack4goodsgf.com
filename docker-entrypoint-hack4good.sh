#!/bin/bash
set -Eeuo pipefail

if [[ "${1:-}" == apache2* ]] && [[ "$(id -u)" != 0 ]] \
    && [[ ! -e index.php && ! -e wp-includes/version.php ]]; then
    echo >&2 "WordPress not found in $PWD - copying without directory metadata..."
    tar_args=(--create --file - --null --no-recursion)

    # Match upstream's exclusions so UI-managed plugins, themes, and .htaccess survive.
    for content_path in /usr/src/wordpress/.htaccess /usr/src/wordpress/wp-content/*/*/; do
        content_path="${content_path%/}"
        [[ -e "$content_path" ]] || continue
        content_path="${content_path#/usr/src/wordpress/}"
        if [[ -e "$PWD/$content_path" ]]; then
            tar_args+=(--exclude "./$content_path" --exclude "./$content_path/*")
        fi
    done

    # Directory headers make GNU tar try to chmod root-owned fsGroup directories.
    # Archive only files and symlinks; tar creates missing parent directories itself.
    (
        cd /usr/src/wordpress
        find . ! -type d -print0 | tar "${tar_args[@]}" --files-from -
    ) | tar --extract --file -
fi

mkdir -p /var/www/html/wp-content/mu-plugins
cp /usr/src/wordpress/wp-content/mu-plugins/hack4good-smtp.php /var/www/html/wp-content/mu-plugins/hack4good-smtp.php

exec docker-entrypoint.sh "$@"
