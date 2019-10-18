FROM httpd:2.4.41-alpine

ENV AWSTATS_VERSION 7.7-r0
ENV MOD_PERL_VERSION 2.0.11

RUN apk add --no-cache awstats=${AWSTATS_VERSION} gettext \
    && apk add --no-cache --virtual .build-dependencies gcc libc-dev make wget perl-dev \
    && cd /tmp \
    && wget https://www-eu.apache.org/dist/perl/mod_perl-$MOD_PERL_VERSION.tar.gz \
    && tar xf mod_perl-$MOD_PERL_VERSION.tar.gz \
    && cd mod_perl-$MOD_PERL_VERSION \
    && perl Makefile.PL MP_APXS=/usr/local/apache2/bin/apxs MP_APR_CONFIG=/usr/bin/apr-1-config --cflags --cppflags --includes \
    && make -j4 \
    && mv src/modules/perl/mod_perl.so /usr/local/apache2/modules/ \
    && echo 'LoadModule perl_module modules/mod_perl.so' >> /usr/local/apache2/conf/httpd.conf \
    && echo 'Include conf/awstats_httpd.conf' >> /usr/local/apache2/conf/httpd.conf \
    && cd .. \
    && rm -rf ./mod_perl-$MOD_PERL_VERSION* \
    && apk del .build-dependencies

ADD awstats_env.conf /etc/awstats/
ADD awstats_httpd.conf /usr/local/apache2/conf/
ADD entrypoint.sh /usr/local/bin/

ENV AWSTATS_CONF_LOGFILE "/var/local/log/access.log"
ENV AWSTATS_CONF_LOGFORMAT "%host %other %logname %time1 %methodurl %code %bytesd %refererquot %uaquot"
ENV AWSTATS_CONF_SITEDOMAIN "my_website"
ENV AWSTATS_CONF_HOSTALIASES "localhost 127.0.0.1 REGEX[^.*$]"

ENTRYPOINT ["entrypoint.sh"]
CMD ["httpd-foreground"]
