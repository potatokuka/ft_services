curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chown -R www:www /var/lib/nginx
chown -R www:www /www

. /tmp/get_external-ip-address.sh EXTERNAL_IP wordpress-svc

envsubst '${DB_NAME} ${DB_USER} ${DB_PASSWORD} ${DB_HOST} ${EXTERNAL_IP}' < /tmp/wp-config.php > /www/wp-config.php
rm /tmp/wp-config.php
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

cd /www
su -c "/tmp/wpinstall.sh" - www
rm -rf /root/.wp-cli
