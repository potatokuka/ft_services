#!/bin/sh
# adduser --disabled-password ${SSH_USERNAME}
# echo "${SSH_USERNAME}:${SSH_PASSWORD}" | chpasswd
# dynamic links to services, clean
. /tmp/get_external-ip-address.sh WORDPRESS_SVC wordpress-svc
. /tmp/get_external-ip-address.sh PHPMYADMIN_SVC phpmyadmin-svc
. /tmp/get_external-ip-address.sh GRAFANA_SVC grafana-svc
. /tmp/get_external-ip-address.sh NGINX_SVC nginx-svc
echo "${WORDPRESS_SVC}:${PHPMYADMIN_SVC}"
envsubst '${WORDPRESS_SVC} ${PHPMYADMIN_SVC} ${NGINX_SVC} ${GRAFANA_SVC}' < /tmp/index.html > /www/index.html
rm /tmp/index.html
envsubst '${WORDPRESS_SVC} ${PHPMYADMIN_SVC}' < /tmp/default.conf > /etc/nginx/conf.d/default.conf
rm /tmp/default.conf
# ssh user
adduser --disabled-password ${SSH_USERNAME}
echo "${SSH_USERNAME}:${SSH_PASSWORD}" | chpasswd
