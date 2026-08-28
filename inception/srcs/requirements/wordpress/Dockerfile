FROM debian:bookworm

# PHP ve gerekli eklentileri kur
RUN apt-get update && apt-get install -y \
    php8.2-fpm php8.2-mysql php8.2-curl php8.2-gd \
    php8.2-intl php8.2-mbstring php8.2-soap php8.2-xml php8.2-zip \
    wget curl mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# PHP'nin çalışması için gereken geçici klasörü aç
RUN mkdir -p /run/php

# PROJE ZORUNLULUĞU: WP-CLI'yi indir ve kur
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Klasörleri ayarla
WORKDIR /var/www/html

COPY conf/www.conf /tmp/my_wp.conf
RUN cat /tmp/my_wp.conf >> /etc/php/8.2/fpm/pool.d/www.conf
RUN rm /tmp/my_wp.conf
# ------------------------------------------------------

# Betiğimizi kopyala
COPY tools/setup_wordpress.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup_wordpress.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/setup_wordpress.sh"]