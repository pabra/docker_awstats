#!/usr/bin/env bash

set -ex

PORT="$1"

if [ -z "$PORT" ]; then
    PORT=80
fi

# index page should show expected frameset
diff -u \
    "html.${PORT}.index.txt" \
    <(lynx -dump "http://awstats:${PORT}")

# check details page
diff -u -I 'Last Update:' \
    "html.${PORT}.02-2020_old_and_new_entries.txt" \
    <(lynx -dump "http://awstats:${PORT}/awstats.pl?databasebreak=month&month=02&year=2020&output=main&framename=mainright")

# /var/lib/awstats should contain 1 file
diff -u \
    <(ls -1AF /var/lib/awstats 2>&1) \
    <(echo 'awstats022020.txt')

echo "test 3 on port ${PORT} done"
