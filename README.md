README
======

Awstats container based on `httpd:2.4-alpine` to keep it small.

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
