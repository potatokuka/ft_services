FROM alpine:3.12

LABEL maintainer greed

RUN apk update --no-cache && \
	apk upgrade --no-cache && \
	apk add grafana --no-cache --repository http://dl-2.alpinelinux.org/alpine/edge/community/ \
	sed \
	curl

WORKDIR /usr/share/grafana

COPY srcs/default.yaml /usr/share/grafana/conf/provisioning/datasources/
COPY srcs/dashboards/*.json /usr/share/grafana/conf/provisioning/dashboards/mine/
COPY srcs/dashboards/default.yaml /usr/share/grafana/conf/provisioning/dashboards/

EXPOSE 3000

CMD [ "grafana-server", "web" ]
