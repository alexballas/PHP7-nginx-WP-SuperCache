FROM ubuntu:16.04

MAINTAINER Alex Ballas <alex@ballas.org>

RUN apt-get update; \
    apt-get -y install php-fpm php7.0-mysql php-pear nginx

ADD nginx-config/wp-supercache.conf /etc/nginx/snippets/wp-supercache.conf
ADD nginx-config/default /etc/nginx/sites-available/default
ADD scripts/start.sh /start.sh

RUN chmod 755 /start.sh

EXPOSE 80 443

CMD ["/start.sh"]
