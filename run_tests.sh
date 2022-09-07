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
docker-compose -f test/docker-compose.yml run --rm ${no_tty} awstats-test /bin/sh -c 'wait4ports -t 10 tcp://awstats:80 && test1.sh'
docker-compose -f test/docker-compose.yml exec ${no_tty} awstats awstats_updateall.pl now
docker-compose -f test/docker-compose.yml run --rm ${no_tty} awstats-test test2.sh
docker-compose -f test/docker-compose.yml exec ${no_tty} awstats awstats_updateall.pl now
docker-compose -f test/docker-compose.yml run --rm ${no_tty} awstats-test test3.sh
