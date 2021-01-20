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

print_ip(){
	echo -n "http://" ; kubectl get svc | grep "$1" | awk '{printf "%s",$4}' ; echo -n ":" ; kubectl get svc | grep "$1" | awk '{print $5}' | cut -d ':' -f 1
}

print_ip_page() {
	echo -n "http://" ; kubectl get svc | grep "$1" | awk '{printf "%s",$4}' ; echo -n ":" ; echo -n $(kubectl get svc | grep "$1" | awk '{printf "%s",$5}' | cut -d ':' -f 1 ) ; echo $2
}
# $1 = name, $2 = docker-location, $3 = yaml-location
start_app () {
	printf "$1: "
	if [ "$4" == "--debug" ]
	then
		docker build -t $1 $2 && \
		kubectl apply -f $3
	else
		docker build -t $1 $2 > /dev/null 2>>errlog.txt && \
		kubectl apply -f $3 > /dev/null 2>>errlog.txt
	fi
    RET=$?
	if [ $RET -eq 1 ]
	then
		echo "[${RED}NO${END}]"
	else
		echo "[${GREEN}OK${END}]"
	fi
}

start_app_ip () {
	printf "$1: "
	if [ "$4" == "--debug" ]
	then
		docker build -t $1 $2 && \
		cat $3 | sed -e "s=IPHERE=$(minikube ip)=" | kubectl apply -f -
	else
		docker build -t $1 $2 > /dev/null 2>>errlog.txt && \
		cat $3 | sed -e "s=IPHERE=$(minikube ip)=" | kubectl apply -f - > /dev/null 2>>errlog.txt
	fi
    RET=$?
	if [ $RET -eq 1 ]
	then
		echo "[${RED}NO${END}]"
	else
		echo "[${GREEN}OK${END}]"
	fi
}

#-------------------------------------DEBUG-------------------------------------#
DEUBUG=""
if [ $# -eq 1 ]
then
	DEBUG=1
else
	DEBUG=0
fi

#------------------------------------CLEANUP------------------------------------#

#rm -rf ~/.minikube
#mkdir -p ~/goinfre/.minikube
#ln -s ~/goinfre/.minikube ~/.minikube

:> errlog.txt
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

# minikube start --driver=docker \
# 				--cpus=6 --memory=3900 --disk-size=10g \
# 				--addons=metallb \
# 				--addons=default-storageclass \
# 				--addons=dashboard \
# 				--addons=storage-provisioner \
# 				--addons=metrics-server \
# 				--extra-config=kubelet.authentication-token-webhook=true

#minikube start --vm-driver=virtualbox --cpus=2 --memory=3000 --disk-size=10g --addons metrics-server --addons metallb --addons default-storageclass --addons storage-provisioner --addons dashboard --extra-config=kubelet.authentication-token-webhook=true

#----------------------------------BUILD AND DEPLOY----------------------------------#

eval $(minikube docker-env)
export MINIKUBE_IP=$(minikube ip)
PROJECT_DIR=""

#docker build -t nginx_alpine ./srcss/nginx
cat ./srcs/metallb/metallb-config.yml | sed -e "s=IPHERE=$(minikube ip)-$(minikube ip)=" | kubectl apply -f -
kubectl apply -f ./srcs/read_permissions.yml
start_app "mysql" "./srcs/mysql" "./srcs/mysql/mysql.yml" "$DEBUG"
start_app "influxdb" "./srcs/influxdb" "./srcs/influxdb/influxdb.yml" "$DEBUG"
start_app "ftps" "./srcs/ftps" "./srcs/ftps/ftps.yml" "$DEBUG"
start_app "wordpress" "./srcs/wordpress" "./srcs/wordpress/wordpress.yml" "$DEBUG"
start_app "phpmyadmin" "./srcs/phpmyadmin" "./srcs/phpmyadmin/phpmyadmin.yml" "$DEBUG"
start_app "telegraf" "./srcs/telegraf" "./srcs/telegraf/telegraf.yml" "$DEBUG"
start_app "grafana" "./srcs/grafana" "./srcs/grafana/grafana.yml" "$DEBUG"
start_app "nginx" "./srcs/nginx" "./srcs/nginx/nginx.yml" "$DEBUG"

echo ""
print_ip "nginx-svc"
print_ip "wordpress-svc"
print_ip "phpmyadmin-svc"
print_ip "grafana-svc"
