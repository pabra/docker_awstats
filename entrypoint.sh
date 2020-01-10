#!/bin/sh

/usr/sbin/crond -L /var/lib/awstats/crond.log -l 8
envsubst < /etc/awstats/awstats_env.conf > /etc/awstats/awstats.conf

exec "$@"
