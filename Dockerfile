FROM httpd:2.4.46-alpine

ENV AWSTATS_VERSION 7.8-r0
ENV TZDATA_VERSION 2020c-r0
ENV MOD_PERL_VERSION 2.0.11
ENV MOD_PERL_SHA ca2a9e18cdf90f9c6023e786369d5ba75e8dac292ebfea9900c29bf42dc16f74

RUN apk add --no-cache awstats=${AWSTATS_VERSION} gettext tzdata=${TZDATA_VERSION} \
    && apk add --no-cache --virtual .build-dependencies apr-dev apr-util-dev gcc libc-dev make wget perl-dev \
    && cd /tmp \
    && wget https://www-eu.apache.org/dist/perl/mod_perl-${MOD_PERL_VERSION}.tar.gz \
    && echo "${MOD_PERL_SHA}  mod_perl-${MOD_PERL_VERSION}.tar.gz" | sha256sum -c \
    && tar xf mod_perl-${MOD_PERL_VERSION}.tar.gz \
    && cd mod_perl-${MOD_PERL_VERSION} \
    && perl Makefile.PL MP_APXS=/usr/local/apache2/bin/apxs MP_APR_CONFIG=/usr/bin/apr-1-config --cflags --cppflags --includes \
    && make -j4 \
    && mv src/modules/perl/mod_perl.so /usr/local/apache2/modules/ \
    && echo 'LoadModule perl_module modules/mod_perl.so' >> /usr/local/apache2/conf/httpd.conf \
    && echo 'Include conf/awstats_httpd.conf' >> /usr/local/apache2/conf/httpd.conf \
    && cd .. \
    && rm -rf ./mod_perl-${MOD_PERL_VERSION}* \
    && apk del .build-dependencies

COPY awstats_env.conf /etc/awstats/
COPY awstats_httpd.conf /usr/local/apache2/conf/
COPY entrypoint.sh /usr/local/bin/

ENV AWSTATS_CONF_LOGFILE "/var/local/log/access.log"
ENV AWSTATS_CONF_LOGFORMAT "%host %other %logname %time1 %methodurl %code %bytesd %refererquot %uaquot"
ENV AWSTATS_CONF_SITEDOMAIN "my_website"
ENV AWSTATS_CONF_HOSTALIASES "localhost 127.0.0.1 REGEX[^.*$]"
ENV AWSTATS_CONF_INCLUDE "."

# patch broken /usr/lib/awstats/cgi-bin/lib/mime.pm
COPY 01-mime.pm.patch /tmp/
RUN apk add --no-cache --virtual .patch patch \
    && patch -p1 /usr/lib/awstats/cgi-bin/lib/mime.pm < /tmp/01-mime.pm.patch \
    && unlink /tmp/01-mime.pm.patch \
    && apk del .patch

ENTRYPOINT ["entrypoint.sh"]
CMD ["httpd-foreground"]
