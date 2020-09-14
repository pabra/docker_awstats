#!/usr/bin/env bash

set -e

diff index.txt <( lynx -dump http://awstats:80 )

echo 'tests done'
