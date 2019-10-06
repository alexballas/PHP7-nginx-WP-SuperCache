#!/bin/bash

service php7.2-fpm start
nginx -g 'daemon off;'
