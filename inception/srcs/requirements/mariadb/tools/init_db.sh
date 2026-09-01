#!/bin/bash

set -e

if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    echo "Starting MariaDB initialization..."
    
    service mariadb start

    mariadb -u root << EOF
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
    FLUSH PRIVILEGES;
EOF
    mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
    
else
    echo "MariaDB is already installed..."
fi

echo "Initialization complete. Starting MariaDB in foreground..."
exec mariadbd --user=mysql