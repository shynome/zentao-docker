#!/usr/bin/env bash

[ $DEBUG ] && set -x

if [ "`ls -A /app/zentaopms`" = "" ]; then
  cp -a /var/www/zentaopms/* /app/zentaopms
  touch /app/zentaopms/www/ok.txt
fi

if [ "`cat /app/zentaopms/VERSION`" != "`cat /var/www/zentaopms/VERSION`" ]; then
  cp -a /var/www/zentaopms/* /app/zentaopms
fi

chmod -R 777 /app/zentaopms/www/data
chmod -R 777 /app/zentaopms/tmp
chmod 777 /app/zentaopms/www
chmod 777 /app/zentaopms/config
chmod -R a+rx /app/zentaopms/bin/*

exec /etc/init.d/apache2 -D FOREGROUND
