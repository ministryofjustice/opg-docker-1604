#!/usr/bin/env bash
set -e

apt-get update -qq
apt-get install -y libpcre3-dev zlib1g-dev libssl-dev libossp-uuid-dev uuid build-essential

NGINX_VERSION="1.13.11"

useradd -r nginx
mkdir -p /var/log/nginx &&\

chown nginx:nginx /var/log/nginx

(
  cd /tmp
  wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
  tar -xzf nginx-${NGINX_VERSION}.tar.gz
  cd nginx-${NGINX_VERSION}
   ./configure \
    --user=nginx \
    --group=nginx \
    --prefix=/etc/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --sbin-path=/usr/sbin/nginx \
    --error-log-path=/var/log/nginx/error.log \
    --http-client-body-temp-path=/var/lib/nginx/body \
    --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
    --http-log-path=/var/log/nginx/access.log \
    --http-proxy-temp-path=/var/lib/nginx/proxy \
    --lock-path=/var/lock/nginx.lock \
    --pid-path=/var/run/nginx.pid \
    --with-http_gzip_static_module \
    --with-http_stub_status_module \
    --with-http_ssl_module \
    --with-pcre-jit
  make
  make install
)

mkdir -p /var/lib/nginx/body

rm /tmp/nginx-${NGINX_VERSION}.tar.gz
rm -rf /tmp/nginx-*

apt-get remove -y --purge build-essential
apt-get clean
apt-get autoremove -y
rm -rf /var/lib/cache/* /var/lib/log/* /tmp/* /var/tmp/*