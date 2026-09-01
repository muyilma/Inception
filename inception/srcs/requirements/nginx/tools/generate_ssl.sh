#!/bin/bash
set -e

mkdir -p /etc/nginx/ssl

if [ ! -f /etc/nginx/ssl/inception.crt ]; then
    echo "musyilma.42.fr için SSL sertifikası üretiliyor..."

    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.crt \
        -subj "/C=TR/ST=Istanbul/L=Istanbul/O=42/OU=42/CN=musyilma.42.fr/UID=musyilma"

    chmod 600 /etc/nginx/ssl/inception.key
    chmod 644 /etc/nginx/ssl/inception.crt

    echo "Sertifika başarıyla üretildi!"
else
    echo "Sertifika zaten var. Üretim atlanıyor."
fi

echo "NGINX konfigürasyonu test ediliyor..."
nginx -t
echo "Test başarılı!"

echo "NGINX başlatılıyor..."
exec nginx -g "daemon off;"