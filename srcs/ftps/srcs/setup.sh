#get pasv addr
export PASV_ADDR=""
while [ -z "$PASV_ADDR" ]
do
	. /tmp/get_external-ip-address.sh PASV_ADDR ftps-svc
	sleep 1
done
echo "Found IP: $PASV_ADDR"
#configure vsftpd
echo "$FTPS_USERNAME" > /tmp/usernamez.sh
envsubst '${PASV_ADDR}' < /tmp/vsftpd.conf > /etc/vsftpd/vsftpd.conf
rm /tmp/vsftpd.conf
#add user pass
adduser -D -h /var/ftp -s /bin/false $FTPS_USERNAME
echo "$FTPS_USERNAME:$FTPS_PASSWORD" | /usr/sbin/chpasswd
#run vsftpd
vsftpd /etc/vsftpd/vsftpd.conf
