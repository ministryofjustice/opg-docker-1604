FROM registry.service.opg.digital/opg-php-fpm-1604

RUN apt-get update                                                 &&\
    apt-get install -y php-mysql php-curl libpng12-dev libjpeg-dev &&\
    apt-get clean && apt-get -y autoremove                         &&\
    rm -rf /var/lib/cache/* /var/lib/log/* /tmp/* /var/tmp/*

RUN chown app:app /data

USER app

# Install wordpress
RUN cd /tmp &&\
    wget --no-verbose https://en-gb.wordpress.org/latest-en_GB.tar.gz                  &&\
    tar -xf latest-en_GB.tar.gz                                                        &&\
    rm -rf wordpress/wp-content/themes/*          \
           wordpress/wp-content/plugins/hello.php \
           wordpress/wp-content/plugins/akismet                                        &&\
    mv wordpress/* /data/.                                                             &&\
    rm -rf wordpress latest-en_GB.tar.gz

USER root

# Remove files included from php-fpm container
RUN rm -rf /app/*           &&\
    ln -s /data /app/public

# Add wordpress configuration templates
COPY docker/. /

ENV OPG_SERVICE wordpress
