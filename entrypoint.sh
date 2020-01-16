#!/bin/sh

[ -x /usr/local/bin/autorun.sh ] && . /usr/local/bin/autorun.sh

envsubst < /etc/awstats/awstats_env.conf > /etc/awstats/awstats.conf

exec "$@"
