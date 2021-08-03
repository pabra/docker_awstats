FROM httpd:2.4.48-alpine

RUN apk add --no-cache lynx diffutils bash wait4ports

WORKDIR /test

COPY test*.sh /usr/local/bin/
COPY html.*.txt ./
COPY access.log ./
COPY awstats022020.txt ./
