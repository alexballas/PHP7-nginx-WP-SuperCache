FROM ubuntu:18.04

LABEL maintainer="Alex Ballas <alex@ballas.org>"

RUN apt update; \
    apt -y install php7.2-fpm php7.2-mysql php7.2-curl php-pear nginx letsencrypt

ADD nginx-config/wp-supercache.conf /etc/nginx/snippets/wp-supercache.conf
ADD nginx-config/default /etc/nginx/sites-available/default
ADD scripts/start.sh /start.sh
ADD scripts/enablessl.sh /enablessl.sh

RUN sed -i 's/.*server_tokens.*/server_tokens off;/' /etc/nginx/nginx.conf
RUN chmod 755 /start.sh
RUN chmod 755 /enablessl.sh

EXPOSE 80 443

CMD ["/start.sh"]
