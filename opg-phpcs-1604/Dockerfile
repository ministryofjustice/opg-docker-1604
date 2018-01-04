FROM registry.service.opg.digital/opg-php-fpm-1604

RUN pear install PHP_CodeSniffer

VOLUME ["/app"]
WORKDIR /app

ENTRYPOINT ["/usr/bin/phpcs"]
CMD ["--help"]
