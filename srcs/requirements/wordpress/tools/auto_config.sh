#!/bin/sh

sleep 5

rm -rf /var/www/html/*

wget http://wordpress.org/latest.tar.gz
tar xfz latest.tar.gz
echo "Move"
mv wordpress/* /var/www/html/
echo "rm latest"
rm -rf latest.tar.gz
echo "rm wordpress"
rm -rf wordpress

echo "Sed"
sed -i "s/username_here/$MYSQL_USER/g" /var/www/html/wp-config-sample.php
sed -i "s/password_here/$MYSQL_PASSWORD/g" /var/www/html/wp-config-sample.php
sed -i "s/localhost/$MYSQL_HOSTNAME/g" /var/www/html/wp-config-sample.php
sed -i "s/database_name_here/$MYSQL_DATABASE/g" /var/www/html/wp-config-sample.php
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sed -i "s/listen = 127.0.0.1:9000/listen = 0.0.0.0:9000/" /etc/php/7.4/fpm/pool.d/www.conf
chown -R www-data:www-data /var/www/html/


if ! wp core is-installed --allow-root --path='/var/www/html'; then
    echo "Création du site.."
    wp core install --allow-root \
        --url=${DOMAIN_NAME} \
        --title=site-42-inception \
        --admin_user=adRafael\
        --admin_password=${MYSQL_ROOT_PASSWORD} \
        --admin_email=rafmb30@gmail.com \
        --skip-email \
        --path='/var/www/html'

    echo "Création du user.."
    wp user create --allow-root \
        ${MYSQL_USER} \
        rafaelmb.lycee@gmail.com \
        --user_pass=${MYSQL_PASSWORD} \
        --role="editor" \
        --display_name=Rafael \
        --porcelain \
        --path='/var/www/html'
fi

echo "Script lu en entier"
# Démarrer PHP-FPM en mode non daemonisé
php-fpm7.4 -F
