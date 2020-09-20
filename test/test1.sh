#!/usr/bin/env bash

set -ex

# index page should show expected frameset
diff -u html.index.txt <( lynx -dump 'http://awstats:80' )

# check details page
diff -u \
    html.02-2020_empty.txt \
    <( lynx -dump 'http://awstats:80/awstats.pl?databasebreak=month&month=02&year=2020&output=main&framename=mainright' )

# /var/lib/awstats should be empty
diff -u \
    <( ls -1AF /var/lib/awstats 2>&1 ) \
    <( echo -n '' )

cp access.log /var/local/log

echo 'tests 1 done'
