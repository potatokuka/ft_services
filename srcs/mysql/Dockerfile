FROM alpine:3.12

RUN	apk update --no-cache && \
	apk upgrade --no-cache && \
	apk add --no-cache mysql \
	mysql-client \
	gettext

#mysql creates a user and group 'mysql' and creates the directory /var/lib/mysql which is owned by user and group 'mysql'
#we need to install the main database in that directory as that is the default value for datadir in the my.cnf config

#the mysqld server will create a .sock file that'll be used as a sort of network pipe, the default path is:
#/run/mysqld/mysqld.sock which doesnt exist, so we need to either create that folder or change the my.cnf to point to a different folder

COPY ./srcs/startup.sh /tmp/startup.sh
COPY ./srcs/my.cnf /tmp/
COPY ./srcs/create_tables.sql /tmp/

RUN envsubst ${DB_USER} ${DB_PASSWORD} < /tmp/my.cnf > /etc/my.cnf

#alpine-linux runs a deprecated version of mysql, that doesnt have the --initialize option for mysqld
#instead we need to use the mysql_install_db command to install the default mysql database

RUN chmod +x /tmp/startup.sh
VOLUME /var/lib/mysql

ENTRYPOINT ["/bin/sh", "/tmp/startup.sh"]
