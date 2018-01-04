#!/bin/bash
set -e

# install packages required for pecl install
apt install -y php-dev pkg-config

# install ext-mongodb (ubuntu packaged version is 1.1, need ^1.3)
pecl install mongodb
echo "extension=mongodb.so" > /etc/php/7.0/mods-available/mongodb.ini && \
phpenmod mongodb

# install xdebug. It is disabled by default when installed via pecl (ubuntu packaged version is 2.4, need ^2.5)
pecl install xdebug

# clean up
apt remove -y --purge php-dev pkg-config
apt clean
apt autoremove -y
rm -rf /var/lib/cache/* /var/lib/log/* /tmp/* /var/tmp/*
