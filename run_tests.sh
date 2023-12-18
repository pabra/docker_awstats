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

run_tests() {
    export HTTPD_PORT="$1"
    export USER="$2"
    docker-compose -f test/docker-compose.yml up -d
    docker-compose -f test/docker-compose.yml run --rm ${no_tty} awstats-test /bin/sh -c "wait4ports -t 10 tcp://awstats:$HTTPD_PORT"
    docker-compose -f test/docker-compose.yml run --rm ${no_tty} awstats-test test1.sh "$HTTPD_PORT"
    docker-compose -f test/docker-compose.yml exec ${no_tty} awstats awstats_updateall.pl now
    docker-compose -f test/docker-compose.yml run --rm ${no_tty} awstats-test test2.sh "$HTTPD_PORT"
    docker-compose -f test/docker-compose.yml exec ${no_tty} awstats awstats_updateall.pl now
    docker-compose -f test/docker-compose.yml run --rm ${no_tty} awstats-test test3.sh "$HTTPD_PORT"
}

if [ "$1" != 'skip_build' ]; then
    docker-compose -f test/docker-compose.yml build
fi

run_tests 80 0

cleanup

run_tests 4567 1234
