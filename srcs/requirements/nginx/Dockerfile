FROM debian:buster

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y apt-utils
RUN apt-get install -y nginx openssl

RUN mkdir -p /etc/nginx/ssl

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

COPY ./conf/rmichel-.conf /etc/nginx/sites-available/rmichel-.conf

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/nginx/ssl/rmichel-.key \
  -out /etc/nginx/ssl/rmichel-.crt \
  -subj "/C=FR/ST=France/L=Paris/O=42School/OU=rmichel-/CN=rmichel-.42.fr"

RUN rm -f /etc/nginx/sites-enabled/default && ln -s /etc/nginx/sites-available/rmichel-.conf /etc/nginx/sites-enabled/

EXPOSE	443
  
  
CMD ["nginx", "-g", "daemon off;"]

