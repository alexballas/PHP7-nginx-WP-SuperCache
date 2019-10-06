#!/bin/bash

domainName=$1
mailAddr=$2

if [ -z "$1" ] || [ -z "$2" ]
then
 echo "Error: No arguments passed"
 echo "Example usage ./enablessl.sh examples.com mail@address.com"
 exit
fi

openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

letsencrypt certonly --agree-tos --email $mailAddr -a webroot --webroot-path=/var/www/html -d $domainName -d www.$domainName

echo "ssl_certificate /etc/letsencrypt/live/$domainName/fullchain.pem;" > /etc/nginx/snippets/ssl-$domainName.conf
echo "ssl_certificate_key /etc/letsencrypt/live/$domainName/privkey.pem;" >> /etc/nginx/snippets/ssl-$domainName.conf

cat <<EOT >> /etc/nginx/snippets/ssl-params.conf
# from https://cipherli.st/
# and https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html

ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
ssl_prefer_server_ciphers on;
ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH";
ssl_ecdh_curve secp384r1;
ssl_session_cache shared:SSL:10m;
ssl_session_tickets off;
ssl_stapling on;
ssl_stapling_verify on;
resolver 1.1.1.1 1.0.0.1 valid=300s;
resolver_timeout 5s;
# Disable preloading HSTS for now.  You can use the commented out header line that includes
# the "preload" directive if you understand the implications.
#add_header Strict-Transport-Security "max-age=63072000; includeSubdomains; preload";
add_header Strict-Transport-Security "max-age=63072000; includeSubdomains";
add_header X-Frame-Options DENY;
add_header X-Content-Type-Options nosniff;

ssl_dhparam /etc/ssl/certs/dhparam.pem;
EOT

sed -i "/server_name/c\  server_name $domainName www.$domainName;" /etc/nginx/sites-available/default
sed -i "/listen \[.*443/a\  include snippets/ssl-$domainName.conf;\n  include snippets/ssl-params.conf;" /etc/nginx/sites-available/default
sed -i "/return 301/c\  return 301 https://www.$domainName\$request_uri;" /etc/nginx/sites-available/default

nginx -s reload
