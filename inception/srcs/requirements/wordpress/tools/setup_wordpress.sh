#!/bin/bash
set -e

WP_PATH="/var/www/html"

# Klasörde wp-config.php yoksa (yani ilk kez kuruluyorsa) işlemleri yap
if [ ! -f "$WP_PATH/wp-config.php" ]; then
    echo "WP-CLI ile WordPress indiriliyor..."
    # 1. WordPress çekirdeğini indir
    wp core download --allow-root --path=$WP_PATH

    echo "Veritabanı bağlantısı ayarlanıyor..."
    # 2. MariaDB ile bağlantı ayarlarını yap (.env dosyasından çekerek)
    # mariadb:3306 ileride docker-compose'da vereceğimiz isimdir
    wp config create \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=mariadb:3306 \
        --allow-root --path=$WP_PATH

    echo "WordPress kuruluyor ve Admin hesabı yaratılıyor..."
    # 3. WordPress'i kur ve Admin kullanıcısını oluştur (Proje kuralı)
    wp core install \
        --url=musyilma.42.fr \
        --title="Inception Projesi" \
        --admin_user=$WP_ADMIN \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --allow-root --path=$WP_PATH

    echo "İkinci normal kullanıcı yaratılıyor..."
    # 4. Normal bir yazar/kullanıcı oluştur (Proje kuralı)
    wp user create $WP_USER $WP_USER_EMAIL \
        --role=author \
        --user_pass=$WP_USER_PASSWORD \
        --allow-root --path=$WP_PATH

    # Güvenlik izinleri
    chown -R www-data:www-data $WP_PATH
    chmod -R 755 $WP_PATH

    echo "WordPress kurulumu başarıyla tamamlandı!"
else
    echo "WordPress zaten kurulu, kurulum atlanıyor."
fi

# PHP-FPM'i ön planda (PID 1) başlat
echo "PHP-FPM başlatılıyor..."
exec php-fpm8.2 -F