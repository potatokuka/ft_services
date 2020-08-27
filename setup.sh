#!/bin/bash

#------------------------------------COLORS------------------------------------#
RED=$'\e[1;31m'
GREEN=$'\e[1;32m'
YELLOW=$'\e[1;33m'
BLUE=$'\e[1;34m'
MAGENTA=$'\e[1;35m'
CYAN=$'\e[1;36m'
END=$'\e[0m'

#------------------------------------FUNCTIONS------------------------------------#

# $1 = name, $2 = docker-location, $3 = yml-location, $4 = DEBUG
start_app () {
	printf "$1: "
	if [ $4 -eq 0 ]
	then
		docker build -t $1 $2 > /dev/null 2>>errlog.txt && kubectl apply -f $3 > /dev/null 2>>errlog.txt
	else
		docker build -t $1 $2 && kubectl apply -f $3
	fi
    RET=$?
	if [ $RET -eq 1 ]
	then
		echo "[${RED}NO${END}]"
	else
		echo "[${GREEN}OK${END}]"
	fi
}

#------------------------------------CLEANUP------------------------------------#

#rm -rf ~/.minikube
#mkdir -p ~/goinfre/.minikube
#ln -s ~/goinfre/.minikube ~/.minikube

:> errlog.txt
:> log.log
#sh cleanup.sh >> log.log 2>> /dev/null

#---------------------------------CLUSTER START---------------------------------#

minikube start	--vm-driver=virtualbox \
				--cpus=2 --memory=3000 --disk-size=10g \
				--addons metallb \
				--addons default-storageclass \
				--addons dashboard \
				--addons storage-provisioner \
				--addons metrics-server \
  				--extra-config=kubelet.authentication-token-webhook=true

#minikube start --vm-driver=virtualbox --cpus=2 --memory=3000 --disk-size=10g --addons metrics-server --addons metallb --addons default-storageclass --addons storage-provisioner --addons dashboard --extra-config=kubelet.authentication-token-webhook=true

#----------------------------------BUILD AND DEPLOY----------------------------------#

eval $(minikube docker-env)
export MINIKUBE_IP=$(minikube ip)

DEUBUG=""
if [ $# -eq 1 ]
then
	DEBUG=1
else
	DEBUG=0
fi

#docker build -t nginx_alpine ./srcss/nginx

kubectl apply -f ./srcs/metallb/metallb-config.yml
start_app "nginx" "./srcs/nginx" "./srcs/nginx.yml" "$DEBUG"
start_app "ftps" "./srcs/ftps" "./srcs/ftps.yml" "$DEBUG"
start_app "mysql" "./srcs/mysql" "./srcs/mysql/mysql.yml"
start_app "wordpress" "./srcs/wordpress" "./srcs/wordpress/wordpress.yml"
start_app "phpmyadmin" "./srcs/phpmyadmin" "./srcs/phpmyadmin/phpmyadmin.yml"
