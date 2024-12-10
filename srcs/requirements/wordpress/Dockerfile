FROM debian:bullseye

RUN apt-get update -y && apt upgrade -y
RUN apt-get install -y apt-utils
RUN apt-get install -y php7.4-fpm php7.4-mysql mariadb-client wget curl vim


RUN mkdir -p /var/www/html && rm -rf /var/www/html/
RUN mkdir /var/www/html/
RUN chown -R www-data:www-data /var/www/html/
RUN chmod -R 755 /var/www/html/

#RUN chmod 777 /var/www/html
RUN wget https://fr.wordpress.org/wordpress-6.4.3-fr_FR.tar.gz -O /tmp/wordpress.tar.gz
RUN tar -xzvf /tmp/wordpress.tar.gz -C /var/www/html --strip-components=1
RUN rm /tmp/wordpress.tar.gz
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

RUN chmod 755 /usr/local/bin/

COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY tools/auto_config.sh /usr/local/bin/auto_config.sh

RUN chmod +x /usr/local/bin/auto_config.sh

RUN mkdir /run/php/
RUN chmod 755 /run/php

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/auto_config.sh"]
