FROM httpd:2.4.63-alpine

ARG MOD_PERL_VERSION=2.0.13
ARG MOD_PERL_SHA=ade3be31c447b8448869fecdfcace258d6d587b8c6c773c5f22735f70d82d6da

COPY src_modules_perl_modperl__common__util.c.patch /tmp/

ARG TARGETPLATFORM

RUN apk add --no-cache gettext \
    && apk add --no-cache --virtual .build-dependencies apr-dev apr-util-dev gcc libc-dev make wget patch perl-dev \
    && cd /tmp \
    && wget https://dlcdn.apache.org/perl/mod_perl-${MOD_PERL_VERSION}.tar.gz \
    && echo "${MOD_PERL_SHA}  mod_perl-${MOD_PERL_VERSION}.tar.gz" | sha256sum -c \
    && tar xf mod_perl-${MOD_PERL_VERSION}.tar.gz \
    && cd mod_perl-${MOD_PERL_VERSION} \
    && mv ../src_modules_perl_modperl__common__util.c.patch ./ \
    && if [ "${TARGETPLATFORM}" = "linux/arm/v7" ] || [ "${TARGETPLATFORM}" = "linux/386" ] ; \
            then patch src/modules/perl/modperl_common_util.c < src_modules_perl_modperl__common__util.c.patch ; \
            else echo 'no patching' ; \
       fi \
    && perl Makefile.PL MP_APXS=/usr/local/apache2/bin/apxs MP_APR_CONFIG=/usr/bin/apr-1-config --cflags --cppflags --includes \
    && make -j4 \
    && mv src/modules/perl/mod_perl.so /usr/local/apache2/modules/ \
    && echo 'LoadModule perl_module modules/mod_perl.so' >> /usr/local/apache2/conf/httpd.conf \
    && echo 'Include conf/awstats_httpd.conf' >> /usr/local/apache2/conf/httpd.conf \
    && cd .. \
    && rm -rf ./mod_perl-${MOD_PERL_VERSION}* \
    && apk del --no-cache .build-dependencies

ARG TZDATA_VERSION=2025a-r0
ARG AWSTATS_VERSION=7.9-r0

RUN apk add --no-cache awstats=${AWSTATS_VERSION} tzdata=${TZDATA_VERSION} \
    && touch /etc/awstats/awstats.conf \
    && touch /usr/local/apache2/conf/awstats_httpd.conf \
    && touch /usr/local/apache2/conf/httpd.conf \
    && chmod g+w /etc/awstats/awstats.conf \
    && chmod g+w /usr/local/apache2/conf/awstats_httpd.conf \
    && chmod g+w /usr/local/apache2/conf/httpd.conf \
    && chmod -R g+w /usr/local/apache2/logs \
    && chmod -R g+w /var/lib/awstats \
    && sed 's/^Listen 80/Listen $HTTPD_PORT/' /usr/local/apache2/conf/httpd.conf > /usr/local/apache2/conf/httpd_env.conf

COPY awstats_env.conf /etc/awstats/
COPY awstats_httpd_env.conf /usr/local/apache2/conf/
COPY entrypoint.sh /usr/local/bin/

ENV AWSTATS_CONF_ALLOWFULLYEARVIEW=2
ENV AWSTATS_CONF_HOSTALIASES="localhost 127.0.0.1 REGEX[^.*$]"
ENV AWSTATS_CONF_INCLUDE="."
ENV AWSTATS_CONF_LOGFILE="/var/local/log/access.log"
ENV AWSTATS_CONF_LOGFORMAT="%host %other %logname %time1 %methodurl %code %bytesd %refererquot %uaquot"
ENV AWSTATS_CONF_SITEDOMAIN="my_website"
ENV AWSTATS_CONF_SKIP_FILES=""
ENV AWSTATS_CONF_SKIP_HOSTS=""
ENV AWSTATS_CONF_SKIP_USER_AGENTS=""
ENV HTTPD_PORT="80"

ENTRYPOINT ["entrypoint.sh"]
CMD ["httpd-foreground"]
