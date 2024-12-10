#!/bin/bash

# Vérification des permissions

mysqld --datadir=/var/lib/mysql &
pid=$!

# Attendre que MariaDB soit prêt
for i in {1..10}; do
    if mysqladmin ping -u root --silent; then
        break
    fi
    echo "Attente de MariaDB..."
    sleep 2
done

if ! mysqladmin ping -u root --silent; then
    echo "MariaDB ne s'est pas lancé correctement."
    exit 1
fi

# Initialisation SQL
echo "Création de l'utilisateur et de la base..."
mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';"
mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"

# Lancer le processus principal `mysqld`
kill $pid
sleep 4
echo "C'est pas infini"
exec mysqld --datadir=/var/lib/mysql
echo "Kaikipass"
