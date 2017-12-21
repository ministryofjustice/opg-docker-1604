#!/bin/bash
set -e

# install packages required for pecl install
apt install -y php-dev pkg-config

# install ext-mongodb (ubuntu packaged version is 1.1, need ^1.3)
pecl install mongodb
echo "extension=mongodb.so" > /etc/php/7.0/mods-available/mongodb.ini && \
phpenmod mongodb

# install xdebug but disable by default (ubuntu packaged version is 2.4, need ^2.5)
pecl install xdebug
rm -f /etc/php/7.0/fpm/conf.d/*xdebug* && \
rm -f /etc/php/7.0/cli/conf.d/*xdebug* && \
rm /etc/php/7.0/mods-available/xdebug.ini

# clean up
apt remove -y --purge php-dev pkg-config
apt clean
apt autoremove -y
rm -rf /var/lib/cache/* /var/lib/log/* /tmp/* /var/tmp/*
