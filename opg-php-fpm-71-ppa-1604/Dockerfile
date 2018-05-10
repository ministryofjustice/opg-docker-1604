FROM registry.service.opg.digital/opg-nginx-1604

ADD  docker/confd /etc/confd
ADD  docker/logrotate.d/app /etc/logrotate.d/app
ADD  docker/my_init.d /etc/my_init.d
ADD  docker/nginx /etc/nginx
ADD  docker/service/php-fpm /etc/sv/php-fpm

ENV  STATSD_HOST monitoring
ENV  STATSD_PORT 8125
ENV  STATSD_DELAY 10
ENV  FPM_STATUS_URL http://localhost:81/status
ENV  OPG_STACKNAME php-fpm

ENV  OPG_PHP_POOL_USER app
ENV  OPG_PHP_POOL_GROUP app
ENV  OPG_PHP_POOL_CHILDREN_MAX 4
ENV  OPG_PHP_POOL_REQUESTS_MAX 0
ENV  OPG_PHP_POOL_REQUEST_TERMINATE_TIMEOUT 60
ENV  OPG_PHP_POOL_MEMORY_LIMIT 256M
ENV  OPG_PHP_POOL_POST_MAX_SIZE 64M
ENV  OPG_PHP_POOL_UPLOAD_MAX_FILESIZE 64M
ENV  OPG_PHP_POOL_MAX_INPUT_VARS 1000

ARG PHP_PACKAGES="mongodb-clients \
                  php-xdebug \
                  postgresql-client \
                  php7.1 \
                  php7.1-cli \
                  php7.1-curl \
                  php7.1-fpm \
                  php7.1-imagick \
                  php7.1-intl\
                  php7.1-mbstring \
                  php7.1-mcrypt \
                  php7.1-mongo \
                  php7.1-pgsql \
                  php7.1-xml \
                  sudo"


RUN apt-get update -y && \
# Add ondrej PPA and install above packages
    apt-get install -y python-software-properties && \
    add-apt-repository -y ppa:ondrej/php && \
    apt-get update -y && \
    apt-get install $PHP_PACKAGES -y && \
    apt clean && apt -y autoremove && \
# Make sure all of our scripts are executable
    chmod a+x /etc/my_init.d/* && \
# Create session data folder
    mkdir -p /data/session && \
# Install composer
    cd /tmp && \
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
# Disable and customise  PHP7.1's XDebug
    phpdismod -v 7.1 xdebug && \
    echo "xdebug.remote_enable=on\nxdebug.remote_port=9000\nxdebug.remote_host=10.254.254.254" \
        >> /etc/php/7.1/mods-available/xdebug.ini && \
# Replace the original php-fpm configuration and prepare our our service runner
    rm -f /etc/php/7.1/fpm/php-fpm.conf /etc/php/7.1fpm/pool.d/www.conf /etc/cron.d/php && \
    chmod a+x /etc/sv/php-fpm/run && \
    ln -s /etc/sv/php-fpm /etc/service/ && \
# Clean up
    rm -rf /var/lib/cache/* /var/lib/log/* /tmp/* /var/tmp/*
