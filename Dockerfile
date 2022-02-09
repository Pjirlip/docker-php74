## HEAD
FROM  alpine:latest
LABEL maintainer="Philipp Dippel <dev@pjirlip.eu>"
LABEL org.opencontainers.image.source=https://github.com/pjirlip/docker-php7

## SET ENV VARS
ENV PROVISION_CONTEXT "production"
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV TZ Europe/Berlin

ENV SERVER_NAME pjirlip.eu
ENV DOCUMENT_ROOT /var/www/html/
ENV PORT 80

ENV PHP_POST_AND_UPLOAD_MAX_SIZE 10M
ENV PHP_MAX_EXEC_TIME 90
ENV PHP_MEMORY_LIMIT 128M

ENV MUSL_LOCPATH /usr/share/i18n/locales/musl
ENV LC_ALL en_US.UTF-8 
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en 

## PRE-SETUP 
RUN apk update && apk upgrade && apk add --no-cache \
    bash bash-doc bash-completion \
    supervisor \
    nginx \
    gettext \
    vim wget git msmtp musl-locales\
    php7 php7-fpm php7-opcache php7-gd php7-common php7-bcmath php7-intl \
    php7-imap php7-json php7-iconv php7-mbstring php7-mysqli php7-xml php7-zip \
    php7-openssl php7-curl php7-fileinfo php7-session

SHELL ["/bin/bash", "-c"]
COPY ./scripts/*.sh /usr/local/bin/
COPY ./config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./config/nginx/nginx.conf.tmpl /etc/nginx/nginx.conf.tmpl
COPY ./config/nginx/site.conf.tmpl /etc/nginx/sites-available/site.conf.tmpl
COPY ./config/php/php-fpm.conf /etc/php7/php-fpm.conf
RUN rm /etc/php7/php-fpm.d/*
COPY ./config/php/pool.conf /etc/php7/php-fpm.d/pool.conf
COPY ./config/php/php.ini /etc/php7/conf.d/php.ini
COPY ./config/locale.gen /etc/locale.gen
RUN chmod +x /usr/local/bin/*.sh

## SETUP
RUN adduser --disabled-password --uid 1000 --shell /bin/bash --home /home/web web
RUN envsubst < /etc/nginx/nginx.conf.tmpl > /etc/nginx/nginx.conf
RUN ls -lisa /etc/nginx/
RUN mkdir -p /etc/nginx/sites-enabled/ 

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

RUN mkdir -p /var/www/html && mkdir -p /home/web/ && cd /home/web && ln -s ${DOCUMENT_ROOT} webroot

WORKDIR /home/web

## RUN
EXPOSE $PORT
CMD ["startup.sh"]
