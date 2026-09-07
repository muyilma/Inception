#!/bin/bash
set -e

WP_PATH="/var/www/html"

if [ ! -f "$WP_PATH/wp-config.php" ]; then
    wp core download --allow-root --path=$WP_PATH

    wp config create \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=mariadb:3306 \
        --allow-root --path=$WP_PATH

    wp core install \
        --url=musyilma.42.fr \
        --title="Inception Project" \
        --admin_user=$WP_ADMIN \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --allow-root --path=$WP_PATH

    wp user create $WP_USER $WP_USER_EMAIL \
        --role=author \
        --user_pass=$WP_USER_PASSWORD \
        --allow-root --path=$WP_PATH

    chown -R www-data:www-data $WP_PATH
    chmod -R 755 $WP_PATH

else
    echo "WordPress is already installed, the installation is being skipped."
fi

exec php-fpm8.2 -F