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
diff -u \
    "html.${PORT}.02-2020_empty.txt" \
    <(lynx -dump "http://awstats:${PORT}/awstats.pl?databasebreak=month&month=02&year=2020&output=main&framename=mainright")

# /var/lib/awstats should be empty
diff -u \
    <(ls -1AF /var/lib/awstats 2>&1) \
    <(echo -n '')

cp access.log /var/local/log

echo "test 1 on port ${PORT} done"
