#!/bin/sh

envsubst < /etc/awstats/awstats_env.conf > /etc/awstats/awstats.conf

exec "$@"
