#!/bin/sh
# Joel DeTeves / 2018
set -e

if [ ! -f /data/upload/.installed ]; then
  sleep 10
  echo Installing X2CRM...
  cp /data/bin/installConfig.php /data/upload/installConfig.php
  php /data/upload/initialize.php silent
  touch /data/upload/.installed

  echo Applying configuration file security...
  chown -R www-data:www-data /data/upload/
  chmod -R a+rX /data/upload/
  chmod -R u+rw /data/upload/
fi

# Configure nginx / logging
mkdir -p /run/nginx
chown -R www-data:www-data /run/nginx
chown -R www-data:www-data /var/lib/nginx
chown -R www-data:www-data /var/tmp/nginx
mkdir -p /var/log/php
chown -R www-data:www-data /var/log/php

echo Launching supervisord...
exec /usr/bin/supervisord -c /data/supervisord.conf
