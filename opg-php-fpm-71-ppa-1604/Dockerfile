FROM registry.service.opg.digital/opg-nginx-1604

ENV PHP_PACKAGES="mcrypt \
                  mongodb-clients \
                  php-xdebug \
                  postgresql-client \
                  php7.1 \
                  php7.1-cli \
                  php7.1-curl \
                  php7.1-fpm \
                  php7.1-imagick \
                  php7.1-mbstring \
                  php7.1-mcrypt \
                  php7.1-mongo \
                  php7.1-pgsql \
                  php7.1-xml"

RUN apt-get install -y python-software-properties && \
    add-apt-repository -y ppa:ondrej/php && \
    apt-get update -y && \
    apt-get install $PHP_PACKAGES -y && \
    apt clean && apt -y autoremove && \
    rm -rf /var/lib/cache/* /var/lib/log/* /tmp/* /var/tmp/* && \
    cd /tmp && \
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

RUN rm -f /etc/php/7.1/fpm/php-fpm.conf /etc/php/7.1fpm/pool.d/www.conf /etc/cron.d/php && \
    mkdir -p /data/session

ADD  docker/confd /etc/confd

ADD  docker/service/php-fpm /etc/sv/php-fpm
RUN  chmod a+x /etc/sv/php-fpm/run && \
     ln -s /etc/sv/php-fpm /etc/service/

RUN  echo "<?php echo phpinfo(); ?>" > /app/public/info.php && \
     chown app /app/public/info.php

ADD  docker/logrotate.d/app /etc/logrotate.d/app

ADD  docker/my_init.d /etc/my_init.d
RUN  chmod a+x /etc/my_init.d/*

ADD  docker/php/* /etc/php/7.1/

# disable php-xdebug by default
RUN  rm -f /etc/php/7.1/fpm/conf.d/*xdebug* && \
     rm -f /etc/php/7.1/cli/conf.d/*xdebug* && \
     rm /etc/php/7.1/mods-available/xdebug.ini

ADD  docker/nginx /etc/nginx

RUN  pip install schedule statsd requests && \
     curl -s https://raw.githubusercontent.com/ministryofjustice/php-fpm-stats-collector/master/php-fpm-stats-collector.py > /usr/local/bin/php-fpm-stats-collector.py && \
     chmod a+x /usr/local/bin/php-fpm-stats-collector.py

ADD  docker/service/php-fpm-stats /etc/sv/php-fpm-stats
RUN  chmod a+x /etc/sv/php-fpm-stats/run && ln -s /etc/sv/php-fpm-stats /etc/service/

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
