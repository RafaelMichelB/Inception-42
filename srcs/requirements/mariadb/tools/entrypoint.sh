#!/bin/bash

# Démarrer le service MariaDB
mysqld --datadir=/var/lib/mysql &
sleep 10

ls -ld /var/run/mysqld

echo "Creating user..."
mysql -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';"

mysql -e "FLUSH PRIVILEGES;"

echo "Generating database..."
mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"

# Exécuter le script SQL d'initialisation
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" 
if [ $? -ne 0 ]; then
    echo "Échec de l'exécution du script SQL"
    exit 1
fi

echo "=== Script SQL exécuté avec succès ==="

# Fonction de surveillance pour garder le conteneur en cours d'exécution
while true; do
    sleep 60
    if ! pgrep mysqld > /dev/null; then
        echo "Le service MySQL s'est arrêté, redémarrage..."
        service mysql restart
    fi
done
