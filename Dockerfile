FROM php:7.0-fpm-alpine
MAINTAINER Joel DeTeves <joel@perfectleap.com>

# setup workdir
RUN mkdir /data
WORKDIR /data

# environment for x2crm
ENV X2CRM_VERSION master
ENV HOME /data

# requirements and PHP extensions
RUN apk add --update \
    wget \
    unzip \
    msmtp \
    mariadb-client \
    ca-certificates \
    supervisor \
    nginx \
    c-client \
    krb5-dev \
    libmcrypt-dev \
    libssh2-dev \
    zlib-dev \
    openssl && \
    apk add imap-dev libpng libpng-dev curl-dev gettext-dev libxml2-dev icu-dev autoconf g++ make pcre-dev && \
    docker-php-ext-install gd curl mysqli sockets gettext mbstring mcrypt opcache zip pdo_mysql && \
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-install imap && \
    pecl install apcu && docker-php-ext-enable apcu && \
    pecl install ssh2-1.1.2 && docker-php-ext-enable ssh2 && \
    apk del imap-dev libpng-dev curl-dev openldap-dev gettext-dev libxml2-dev icu-dev autoconf g++ make pcre-dev && \
    rm -rf /var/cache/apk/*

# Download & install x2crm
RUN wget -nv -O x2crm.tar.gz https://github.com/X2Engine/X2CRM/archive/${X2CRM_VERSION}.tar.gz && \
    tar -xvzf x2crm.tar.gz && \
    rm x2crm.tar.gz && \
    mv X2CRM-${X2CRM_VERSION}/x2engine ./upload && \
    rm -r X2CRM-${X2CRM_VERSION}

# Configure nginx, PHP, msmtp and supervisor
COPY nginx.conf /etc/nginx/nginx.conf
COPY php-x2crm.ini $PHP_INI_DIR/conf.d/
RUN touch /var/log/msmtp.log && \
    chown www-data:www-data /var/log/msmtp.log
COPY supervisord.conf /data/supervisord.conf
COPY msmtp.conf /data/msmtp.conf
COPY php.ini $PHP_INI_DIR/php.ini

COPY bin/ /data/bin

VOLUME ["/var/log/nginx"]
EXPOSE 80
CMD ["/data/bin/start.sh"]
