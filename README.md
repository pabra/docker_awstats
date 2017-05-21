README
======

Awstats container based on `httpd:2.4-alpine` to keep it small. It's configures
that way, so you can easily put a reverse proxy (like Nginx) in front.

Read all about [awstats config](http://www.awstats.org/docs/awstats_config.html)


Quickstart
----------

```bash
# start the container
docker run \
    --detach \
    --restart always \
    --publish 3000:80 \
    --name awstats \
    --volume /var/log/nginx:/var/local/log:ro \
    --volume /var/lib/awstats:/var/lib/awstats \
    pabra/awstats

# ensure awstats can read your logs
docker exec awstats awstats_updateall.pl now
```

Now point your browser to [http://my_website:3000/]().

Add this line to your `/etc/crontab` to let Awstats analyze your logs every 10 minutes:
```
*/10 * * * * root docker exec awstats awstats_updateall.pl now > /dev/null
```


Advanced
========

Analyze old log files
---------------------

Awstats only processes lines in log files that are newer than the newest already
known line.  
Means: You cannot analyze older log files later. Start with oldest ones first.
You may need to delete already processed data by `rm /var/lib/awstats/*`

```bash
LOGFILES=(
    "gunzip -c /var/local/log/access.log.52.gz |"
    "gunzip -c /var/local/log/access.log.51.gz |"
    "gunzip -c /var/local/log/access.log.50.gz |"
    "gunzip -c /var/local/log/access.log.49.gz |"
    "gunzip -c /var/local/log/access.log.48.gz |"
    "gunzip -c /var/local/log/access.log.47.gz |"
    "gunzip -c /var/local/log/access.log.46.gz |"
    "gunzip -c /var/local/log/access.log.45.gz |"
    "gunzip -c /var/local/log/access.log.44.gz |"
    "gunzip -c /var/local/log/access.log.43.gz |"
    "gunzip -c /var/local/log/access.log.42.gz |"
    "gunzip -c /var/local/log/access.log.41.gz |"
    "gunzip -c /var/local/log/access.log.40.gz |"
    "gunzip -c /var/local/log/access.log.39.gz |"
    "gunzip -c /var/local/log/access.log.38.gz |"
    "gunzip -c /var/local/log/access.log.37.gz |"
    "gunzip -c /var/local/log/access.log.36.gz |"
    "gunzip -c /var/local/log/access.log.35.gz |"
    "gunzip -c /var/local/log/access.log.34.gz |"
    "gunzip -c /var/local/log/access.log.33.gz |"
    "gunzip -c /var/local/log/access.log.32.gz |"
    "gunzip -c /var/local/log/access.log.31.gz |"
    "gunzip -c /var/local/log/access.log.30.gz |"
    "gunzip -c /var/local/log/access.log.29.gz |"
    "gunzip -c /var/local/log/access.log.28.gz |"
    "gunzip -c /var/local/log/access.log.27.gz |"
    "gunzip -c /var/local/log/access.log.26.gz |"
    "gunzip -c /var/local/log/access.log.25.gz |"
    "gunzip -c /var/local/log/access.log.24.gz |"
    "gunzip -c /var/local/log/access.log.23.gz |"
    "gunzip -c /var/local/log/access.log.22.gz |"
    "gunzip -c /var/local/log/access.log.21.gz |"
    "gunzip -c /var/local/log/access.log.20.gz |"
    "gunzip -c /var/local/log/access.log.19.gz |"
    "gunzip -c /var/local/log/access.log.18.gz |"
    "gunzip -c /var/local/log/access.log.17.gz |"
    "gunzip -c /var/local/log/access.log.16.gz |"
    "gunzip -c /var/local/log/access.log.15.gz |"
    "gunzip -c /var/local/log/access.log.14.gz |"
    "gunzip -c /var/local/log/access.log.13.gz |"
    "gunzip -c /var/local/log/access.log.12.gz |"
    "gunzip -c /var/local/log/access.log.11.gz |"
    "gunzip -c /var/local/log/access.log.10.gz |"
    "gunzip -c /var/local/log/access.log.9.gz |"
    "gunzip -c /var/local/log/access.log.8.gz |"
    "gunzip -c /var/local/log/access.log.7.gz |"
    "gunzip -c /var/local/log/access.log.6.gz |"
    "gunzip -c /var/local/log/access.log.5.gz |"
    "gunzip -c /var/local/log/access.log.4.gz |"
    "gunzip -c /var/local/log/access.log.3.gz |"
    "gunzip -c /var/local/log/access.log.2.gz |"
    "/var/local/log/access.log.1"
    "/var/local/log/access.log"
)
for lf in "${LOGFILES[@]}"; do
    docker exec awstats /usr/lib/awstats/cgi-bin/awstats.pl -update -config=my_website -LogFile="$lf"
done
```
