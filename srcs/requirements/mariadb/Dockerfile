FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y mariadb-server mariadb-client gettext-base procps
RUN apt-get clean

RUN mkdir -p /run/mysqld /var/www && \
    chown mysql:mysql /run/mysqld

# Configuration de MariaDB
COPY conf/my.cnf /etc/mysql/mariadb.conf.d/

# Créer les répertoires pour les sockets et les données
RUN mkdir -p /var/run/mysqld /var/lib/mysql

# Définir les permissions sur les répertoires
RUN chmod 755 /var/run/mysqld /var/lib/mysql

COPY ./tools/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

RUN chmod -R 755 /var/lib/mysql

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
#CMD ["mysqld"]
