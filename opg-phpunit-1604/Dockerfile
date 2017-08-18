FROM registry.service.opg.digital/opg-php-fpm-1604

ADD  docker/phpunit-5.7.21.phar /usr/local/bin/phpunit

# enable php-xdebug for code coverage
RUN cp /etc/php/7.0/xdebug-enable.ini /etc/php/7.0/fpm/conf.d/20-xdebug.ini
RUN cp /etc/php/7.0/xdebug-enable.ini /etc/php/7.0/cli/conf.d/20-xdebug.ini

# We need version 1.2 of the mongo extension
RUN apt-get remove -y php-mongodb

RUN apt-get install -y php-dev pkg-config

RUN pecl install mongodb-1.2.9 && \
    echo "extension=mongodb.so" > /etc/php/7.0/mods-available/mongodb.ini && \
    phpenmod mongodb

VOLUME ["/app"]
WORKDIR /app

ENTRYPOINT ["/usr/local/bin/phpunit"]
CMD ["--help"]