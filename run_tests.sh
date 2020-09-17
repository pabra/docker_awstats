#!/bin/sh

set -e

cleanup() {
    docker-compose -f test/docker-compose.yml down --volumes
}

trap cleanup EXIT INT

if [ "$1" != 'skip_build' ]; then
    docker-compose -f test/docker-compose.yml build
fi

docker-compose -f test/docker-compose.yml up -d
# docker-compose -f test/docker-compose.yml run awstats-test sh
docker-compose -f test/docker-compose.yml run awstats-test wait-for-it.sh awstats:80 -t 10 -- test1.sh
docker-compose -f test/docker-compose.yml exec awstats awstats_updateall.pl now
# docker-compose -f test/docker-compose.yml run awstats-test sh
docker-compose -f test/docker-compose.yml run awstats-test test2.sh
