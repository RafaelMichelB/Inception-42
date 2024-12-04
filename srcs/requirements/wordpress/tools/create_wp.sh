#!/bin/bash

sleep 10

echo "Ecriture dans le fichier wp-config.php.."
cat <<EOL > /var/www/html/wp-config.php
<?php
// ** Réglages MySQL ** //
define('DB_NAME', '${MYSQL_DATABASE}');
define('DB_USER', '${MYSQL_USER}');
define('DB_PASSWORD', '${MYSQL_PASSWORD}');
define('DB_HOST', 'db');

// ** Clés uniques et salages ** //
define('AUTH_KEY',         '3k>>;FCQSp1h5cs/VQT5li+rS6d.D|7*jD-bt^=c6gx|vY<H>b-l~b/0:pN');
define('SECURE_AUTH_KEY',  '97Sh~s>A6YW-5?*UVfWhtCJ=6X41|O<^IKSNJxg+~r3:Z+Lccz;1>=+o|VJy?');
define('LOGGED_IN_KEY',    '|CAxL-Nz:=V>V6/G+pT?u-8Kk92s_<=aQ|!xt2f9UD#+k<9Dp5.un?Sut+xLB');
define('NONCE_KEY',        'sA|%LQr9GNevaqV-Fh^6,<Bif3jz:_8,OFT|zapdF>!N7QCA:i0y|RsE');
define('AUTH_SALT',        'R<Keuq9<qzGp? !,!ParK3kXGA2nEKfjDUVG>Fw7ak|KFwWDmacCCW*mz_g~J');
define('SECURE_AUTH_SALT', 'X_e>9/uvsLUbrMrbo//|*Q7VVWiR-Wb/||b~;xh#z+|=5inXo!>#pfJVsCkmLh');
define('LOGGED_IN_SALT',   'y:o=!|?-zfjb1kcki|?u5H#pK/+9-Os%Lpu5>fQ.L:uwpnM?Jy*/>&>');
define('NONCE_SALT',       '%*NkMx|jM6_|,U1~-yGaoO#d,4YIJmF6qXo8Y:ZteB/gN+elny!BEn,pL');

// ** Préfixe des tables de la base de données ** //
\$table_prefix = 'wp_';

// ** Réglages pour le débogage ** //
define('WP_DEBUG', true);

/* C'est tout, ne touchez pas à ce qui suit ! */
if ( !defined('ABSPATH') )
    define('ABSPATH', dirname(__FILE__) . '/');
require_once(ABSPATH . 'wp-settings.php');
EOL

if ! wp core is-installed --allow-root --path='/var/www/html'; then
    echo "Création du site.."
    wp core install --allow-root \
        --url=${DOMAIN_NAME} \
        --title=${SITE_TITLE} \
        --admin_user=${ADMIN_USER} \
        --admin_password=${ADMIN_PASSWORD} \
        --admin_email=${ADMIN_EMAIL} \
        --skip-email \
        --path='/var/www/html'

    echo "Création du user.."
    wp user create --allow-root \
        ${USER1_LOGIN} \
        ${USER1_EMAIL} \
        --user_pass=${USER1_PASS} \
        --role="editor" \
        --display_name=${USER1_LOGIN} \
        --porcelain \
        --path='/var/www/html'
fi

echo "Script lu en entier"
# Démarrer PHP-FPM en mode non daemonisé
php-fpm7.3 -F
