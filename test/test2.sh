#!/usr/bin/env bash

set -ex

# index page should show expected frameset
diff html.index.txt <( lynx -dump 'http://awstats:80' )

# check details page
diff html.02-2020_with_entries.txt <( lynx -dump 'http://awstats:80/awstats.pl?month=02&year=2020&output=main&framename=mainright' )

# /var/lib/awstats should be empty
diff <( ls -1AF /var/lib/awstats 2>&1 ) <( echo -n '' )

echo 'tests 2 done'
