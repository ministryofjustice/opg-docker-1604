FROM registry.service.opg.digital/opg-nginx-1604

ARG PHP_PACKAGES="php-fpm php-cli php-imagick php-curl php-xml php-pgsql \
                  php-mcrypt php-memcached php-redis php-pear php-mbstring \
                  php-intl php-json mcrypt php-bcmath \
                  postgresql-client mongodb-clients"

ENV PHP_VERSION="7.0" \
    STATSD_HOST="monitoring" \
    STATSD_PORT="8125" \
    STATSD_DELAY="10" \
    FPM_STATUS_URL="http://localhost:81/status" \
    OPG_STACKNAME="php-fpm" \
    OPG_PHP_POOL_USER="app" \
    OPG_PHP_POOL_GROUP="app" \
    OPG_PHP_POOL_CHILDREN_MAX="4" \
    OPG_PHP_POOL_REQUESTS_MAX="0" \
    OPG_PHP_POOL_REQUEST_TERMINATE_TIMEOUT="60" \
    OPG_PHP_POOL_MEMORY_LIMIT="256M" \
    OPG_PHP_POOL_POST_MAX_SIZE="64M" \
    OPG_PHP_POOL_UPLOAD_MAX_FILESIZE="64M" \
    OPG_PHP_POOL_MAX_INPUT_VARS="1000"

RUN apt-get update &&\
    apt-get install -y $PHP_PACKAGES &&\
    apt-get clean && apt-get -y autoremove

RUN rm -f /etc/php/${PHP_VERSION}/fpm/php-fpm.conf "/etc/php/${PHP_VERSION}fpm/pool.d/www.conf" /etc/cron.d/php &&\
    mkdir -p /data/session

COPY docker/. /

RUN echo "Enabling php-fpm service"    &&\
    chmod a+x /etc/sv/php-fpm/run      &&\
    ln -s /etc/sv/php-fpm /etc/service/

RUN echo "<?php echo('hello World :)') ?>" > /app/public/index.php &&\
    chown app /app/public/index.php &&\
    chmod a+x /etc/my_init.d/*

RUN echo "Installing mongodb and xdebug" &&\
    apt-get install -y php-dev pkg-config &&\
    pecl install mongodb &&\
    echo "extension=mongodb.so" > /etc/php/${PHP_VERSION}/mods-available/mongodb.ini &&\
    phpenmod mongodb &&\
    # install xdebug. It is disabled by default when installed via pecl (ubuntu packaged version is 2.4, need ^2.5)
    pecl install xdebug &&\
    apt-get remove -y --purge php-dev pkg-config &&\
    apt-get clean && apt-get autoremove -y &&\
    rm -rf /var/lib/cache/* /var/lib/log/* /tmp/* /var/tmp/*

RUN pip install schedule statsd requests
