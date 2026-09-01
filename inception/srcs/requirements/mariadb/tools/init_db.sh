#!/bin/bash

set -e

echo "Starting MariaDB initialization..."

mysqld --skip-networking  --user=mysql &
pid="$!"
    
echo "Waiting for MariaDB to be ready..."
until mysqladmin  ping >/dev/null 2>&1; do
    sleep 1
done
echo "MariaDB is ready!"

mysql  -u root << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

echo "Shutting down temporary MariaDB..."
mysqladmin  -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown

wait "$pid" || true

echo "Initialization complete. Starting MariaDB..."
exec mysqld --user=mysql 