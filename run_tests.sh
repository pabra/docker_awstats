#!/bin/sh

set -e

cleanup() {
    docker-compose -f test/docker-compose.yml down --volumes
}

trap cleanup EXIT INT

if [ -t 1 ]; then
    no_tty=
else
    no_tty='-T'
fi

if [ "$1" != 'skip_build' ]; then
    docker-compose -f test/docker-compose.yml build
fi

docker-compose -f test/docker-compose.yml up -d
docker-compose -f test/docker-compose.yml run ${no_tty} awstats-test wait-for-it.sh awstats:80 -t 10 -- test1.sh
docker-compose -f test/docker-compose.yml exec ${no_tty} awstats awstats_updateall.pl now
docker-compose -f test/docker-compose.yml run ${no_tty} awstats-test test2.sh
docker-compose -f test/docker-compose.yml exec ${no_tty} awstats awstats_updateall.pl now
docker-compose -f test/docker-compose.yml run ${no_tty} awstats-test test3.sh
