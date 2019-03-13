FROM registry.service.opg.digital/opg-nginx-1604

COPY docker/. /

ENV STATSD_HOST="monitoring" \
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

RUN echo "Adding PHP7.1 PPA" \
  && chmod 1777 /tmp/ \
  && add-apt-repository -y ppa:ondrej/php \
  && apt-get update -y \
  && apt-get install -y sudo \
  python-software-properties \
  mongodb-clients \
  postgresql-client \
  php-xdebug \
  php7.1 \
  php7.1-cli \
  php7.1-curl \
  php7.1-fpm \
  php7.1-imagick \
  php7.1-intl \
  php7.1-mbstring \
  php7.1-mcrypt \
  php7.1-mongo \
  php7.1-pgsql \
  php7.1-xml \
  && apt-get clean \
  && apt-get -y autoremove \
  && update-alternatives --set php /usr/bin/php7.1 \
  && echo "Making sure scripts are executable" \
  && chmod a+x /etc/my_init.d/* \
  && mkdir -p /data/session \
  && echo "Reconfiguring XDebug" \
  && phpdismod -v 7.1 xdebug \
  && echo "xdebug.remote_enable=on\nxdebug.remote_port=9000\nxdebug.remote_host=10.254.254.254" \
  >> /etc/php/7.1/mods-available/xdebug.ini \
  && echo "Replacing php-fpm configuration" \
  && rm -f /etc/php/7.1/fpm/php-fpm.conf /etc/php/7.1fpm/pool.d/www.conf /etc/cron.d/php \
  && chmod a+x /etc/sv/php-fpm/run \
  && ln -s /etc/sv/php-fpm /etc/service/ \
  && echo "Installing Composer" \
  && chmod a+x /tmp/install-composer.sh \
  && source /tmp/install-composer.sh \
  && echo "Clean-up" \
  && rm -rf /var/lib/cache/* /var/lib/log/* /tmp/* /var/tmp/*

EXPOSE 9000
