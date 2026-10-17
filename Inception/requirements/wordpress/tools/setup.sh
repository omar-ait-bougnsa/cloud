#!/bin/bash
set -e

mkdir -p /var/www/wordpress
chown -R www-data:www-data /var/www/wordpress

cd /var/www/wordpress

if [ ! -f "wp-config.php" ]; then
  echo "downloading wordpress core files"
  wp core download --allow-root

  while ! mariadb -h mariadb -u"$WORDPRESS_DB_USER" -p"$WORDPRESS_DB_PASSWORD"; do
      echo "Waiting for MariaDB Connection...";
      sleep 2
  done

  wp config create --allow-root \
    --dbname="$DB_NAME" \
    --dbuser="$WORDPRESS_DB_USER" \
    --dbpass="$WORDPRESS_DB_PASSWORD" \
    --dbhost="$WORDPRESS_DB_HOST"

  echo  "\nInstalling wordpress"

  wp core install --allow-root \
    --url="$URL" \
    --title="$TITLE" \
    --admin_user="$ADMIN_USER" \
    --admin_password="$ADMIN_PASSWORD" \
    --admin_email="$ADMIN_EMAIL"

  wp user create --allow-root \
    "$USER" "$USER_EMAIL" \
    --role=author \
    --user_pass="$USER_PASSWORD"
else
  echo "WordPress already installed, skipping install steps."
fi

echo "\nstarting php-fpm"
exec php-fpm8.2 -F