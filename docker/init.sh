#!/bin/sh

echo "Run InitScripts"
find /initscripts -type f -perm +111 -print -exec {} \;

echo "Start Apache2"
/usr/sbin/httpd -d . -f /etc/apache2/httpd.conf

if [ ! -f /www/index.php ]; then
  echo "Populate '/www' because it's empty"
  echo '<?php phpinfo(); ?>' > /www/index.php
fi

echo "Start PHP-FPM"
/usr/bin/php-fpm
