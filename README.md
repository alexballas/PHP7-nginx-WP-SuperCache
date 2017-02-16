# PHP7-Nginx-WP-SuperCache
A php7-fpm + nginx, WP super cache friendly, SSL ready, docker image.
## Usage
```
sudo docker build -t mynginx .
sudo docker run --name nginx -it -d -p 80:80 -p 443:443 -v /MY/WWW/DIR/:/var/www/html mynginx
```
## SSL support with Let's Encrypt
In the previous example you can enable SSL for domain by running the following command.
```
sudo docker exec -it nginx /enablessl.sh example.com example@email.com
```
No further actions are required.

