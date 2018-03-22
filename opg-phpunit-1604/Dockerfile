FROM registry.service.opg.digital/opg-php-fpm-1604

ARG PHPUNIT_VERSION="6"

RUN cd /tmp && \
    wget https://phar.phpunit.de/phpunit-${PHPUNIT_VERSION}.phar && \
    chmod +x phpunit-${PHPUNIT_VERSION}.phar && \
    mv phpunit-${PHPUNIT_VERSION}.phar /usr/local/bin/phpunit

# enable xdebug for code coverage
RUN cp /etc/php/7.0/xdebug-enable.ini /etc/php/7.0/fpm/conf.d/20-xdebug.ini && \
    cp /etc/php/7.0/xdebug-enable.ini /etc/php/7.0/cli/conf.d/20-xdebug.ini

VOLUME ["/app"]
WORKDIR /app

ENTRYPOINT ["/usr/local/bin/phpunit"]
CMD ["--help"]
