# php-fpm-nginx-wp-super-cache-docker
A php7-fpm + nginx, WP super cache friendly docker image.
## Usage
```
sudo docker build -t mynginx .
sudo docker run -it -d -p 80:80 -v /MY/WWW/DIR/:/var/www/html mynginx
```
## TODO
Support SSL