adduser -D -h /var/ftp $FTPS_USER
echo "$FTPS_USER:$FTPS_PASSWORD" | chpasswd

. /tmp/get_external-ip-address.sh FTPSSVC_IP ftps-svc
envsubst '${FTPSSVC_IP}' < /tmp/vsftpd.conf > /etc/vsftpd/vsftpd.conf
vsftpd /etc/vsftpd/vsftpd.conf