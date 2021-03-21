#!/usr/bin/env bash

set -ex

# index page should show expected frameset
diff -u html.index.txt <(lynx -dump 'http://awstats:80')

# check details page
diff -u -I 'Last Update:' \
    html.02-2020_with_entries.txt \
    <(lynx -dump 'http://awstats:80/awstats.pl?month=02&year=2020&output=main&framename=mainright')

# /var/lib/awstats should contain 1 file
diff -u \
    <(ls -1AF /var/lib/awstats 2>&1) \
    <(echo 'awstats022020.txt')

unlink /var/lib/awstats/awstats022020.txt

cp awstats022020.txt /var/lib/awstats/

# check details page
diff -u -I 'Last Update:' \
    html.02-2020_old_entries.txt \
    <(lynx -dump 'http://awstats:80/awstats.pl?month=02&year=2020&output=main&framename=mainright')

echo 'tests 2 done'
