FROM alpine:3.12

LABEL maintainer greed

RUN apk update --no-cache && \
	apk upgrade --no-cache && \
	apk add telegraf --no-cache --repository http://dl-2.alpinelinux.org/alpine/edge/community

CMD [ "telegraf" ]
