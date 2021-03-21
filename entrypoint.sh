#!/bin/sh

set -e

if [ -x /usr/local/bin/autorun.sh ]; then
    . /usr/local/bin/autorun.sh
fi

envsubst </etc/awstats/awstats_env.conf >/etc/awstats/awstats.conf

exec "$@"
