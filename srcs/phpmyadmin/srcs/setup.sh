. /tmp/get_external-ip-address.sh PHPSVC_IP phpmyadmin-svc
envsubst '${PHPSVC_IP} ${DB_HOST}' < /tmp/config.inc.php > /www/config.inc.php
chown -R www:www /var/lib/nginx
chown -R www:www /wwws
