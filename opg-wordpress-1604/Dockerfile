FROM registry.service.opg.digital/opg-php-fpm-1604

ARG PHP_PACKAGES="php-mysql php-curl libpng12-dev libjpeg-dev"

RUN apt update && \
    apt install -y $PHP_PACKAGES && \
    apt clean && apt -y autoremove && \
    rm -rf /var/lib/cache/* /var/lib/log/* /tmp/* /var/tmp/*

RUN chown app:app /data

USER app

# Install wordpress
RUN cd /tmp && \
    wget --no-verbose https://en-gb.wordpress.org/latest-en_GB.tar.gz && \
    tar -xf latest-en_GB.tar.gz && \
    rm -rf wordpress/wp-content/themes/* && \
    rm -rf wordpress/wp-content/plugins/hello.php wordpress/wp-content/plugins/akismet && \
    mv wordpress/* /data/. && \
    rm -rf wordpress latest-en_GB.tar.gz

# Add wordpress configuration templates
ADD docker/confd /etc/confd

USER root

# Remove files included from php-fpm container
RUN rm -rf /app/* && \
    ln -s /data /app/public

ADD  docker/my_init.d /etc/my_init.d
ADD  docker/nginx/uploadsize.conf /etc/nginx/conf.d/uploadsize.conf
RUN  chmod a+x /etc/my_init.d/*

ENV OPG_SERVICE wordpress
