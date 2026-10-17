#!/bin/bash
set -e

chown -R mysql:mysql /var/run/mysqld
chown -R mysql:mysql /var/lib/mysql

first_time=0
if [ ! -f "/var/lib/mysql/.initialized" ]; then
  touch /var/lib/mysql/.initialized
  first_time=1
fi

service mariadb start

while ! mysqladmin ping ; do
    sleep 2
done

if [ "$first_time" = "1" ]; then
  mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';"
fi

mysql -uroot -p"${DB_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;"
mysql -uroot -p"${DB_ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS '${WORDPRESS_DB_USER}'@'%' IDENTIFIED BY '${WORDPRESS_DB_PASSWORD}';"
mysql -uroot -p"${DB_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${WORDPRESS_DB_USER}'@'%';"
mysql -uroot -p"${DB_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"

mysqladmin -u root -p"${DB_ROOT_PASSWORD}" shutdown

exec mysqld