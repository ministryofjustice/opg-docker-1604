FROM registry.service.opg.digital/opg-php-fpm-1604

RUN apt-get update && apt-get install -y \
    php-pear

RUN pear install PHP_CodeSniffer

VOLUME ["/app"]
WORKDIR /app

ENTRYPOINT ["/usr/bin/phpcs"]
CMD ["--help"]