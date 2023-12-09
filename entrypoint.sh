#!/bin/sh

set -e

if [ -x /usr/local/bin/autorun.sh ]; then
    . /usr/local/bin/autorun.sh
fi

envsubst </etc/awstats/awstats_env.conf >/etc/awstats/awstats.conf
envsubst </usr/local/apache2/conf/awstats_httpd_env.conf >/usr/local/apache2/conf/awstats_httpd.conf
envsubst </usr/local/apache2/conf/httpd_env.conf >/usr/local/apache2/conf/httpd.conf

exec "$@"
