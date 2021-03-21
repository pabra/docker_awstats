FROM httpd:2.4.46-alpine

ARG WAITFORIT_COMMIT=81b1373f17855a4dc21156cfe1694c31d7d1792e
ARG WAITFORIT_SHA256=b7a04f38de1e51e7455ecf63151c8c7e405bd2d45a2d4e16f6419db737a125d6
ARG WAITFORIT_PATH=/usr/local/bin/wait-for-it.sh

RUN apk add --no-cache lynx diffutils bash \
    && wget -O ${WAITFORIT_PATH} "https://raw.githubusercontent.com/vishnubob/wait-for-it/${WAITFORIT_COMMIT}/wait-for-it.sh" \
    && echo "${WAITFORIT_SHA256}  ${WAITFORIT_PATH}" | sha256sum -c \
    && chmod +x ${WAITFORIT_PATH}

WORKDIR /test

COPY test*.sh /usr/local/bin/
COPY html.*.txt ./
COPY access.log ./
COPY awstats022020.txt ./
