FROM registry.service.opg.digital/opg-php-fpm-1604

RUN cd /tmp && \
    wget https://phar.phpunit.de/phpunit.phar && \
    chmod +x phpunit.phar && \
    mv phpunit.phar /usr/local/bin/phpunit

RUN apt-get install -y php-dev pkg-config

# install and enable latest xdebug for code coverage
RUN apt-get remove -y php-xdebug && \
    pecl install xdebug && \
    cp /etc/php/7.0/xdebug-enable.ini /etc/php/7.0/fpm/conf.d/20-xdebug.ini && \
    cp /etc/php/7.0/xdebug-enable.ini /etc/php/7.0/cli/conf.d/20-xdebug.ini

# We need latest version of the mongo extension
RUN pecl install mongodb && \
    echo "extension=mongodb.so" > /etc/php/7.0/mods-available/mongodb.ini && \
    phpenmod mongodb

VOLUME ["/app"]
WORKDIR /app

ENTRYPOINT ["/usr/local/bin/phpunit"]
CMD ["--help"]
