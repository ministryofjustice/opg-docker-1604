FROM registry.service.opg.digital/opg-base-1604

ARG PHP_PACKAGES="libpcre3-dev zlib1g-dev libssl-dev libossp-uuid-dev uuid build-essential"
ARG NGINX_VERSION="1.13.11"
ENV OPG_NGINX_SERVER_NAMES="localhost"
ENV OPG_SERVICE="nginx"

RUN apt update && \
    apt install -y $PHP_PACKAGES

COPY docker/. /

RUN echo "Setup nginx user and dirs" &&\
    useradd -r nginx &&\
    ln -s /etc/sv/nginx /etc/service/ &&\
    mkdir -p /var/log/nginx /var/lib/nginx/body /app/public /etc/nginx/app.conf.d &&\
    chown nginx:nginx /var/log/nginx &&\
    echo "Hello World from opguk/nginx" > /app/public/index.html

WORKDIR /tmp
RUN echo "Compiling nginx" &&\
    wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz &&\
    tar -xzf nginx-${NGINX_VERSION}.tar.gz &&\
    cd nginx-${NGINX_VERSION} &&\
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
        --with-pcre-jit &&\
    make &&\
    make install &&\
    chmod a+x /etc/sv/nginx/run &&\
    rm /tmp/nginx-${NGINX_VERSION}.tar.gz &&\
    rm -rf /tmp/nginx-* &&\
    apt-get remove -y --purge build-essential &&\
    apt clean && apt -y autoremove && \
    rm -rf /var/lib/cache/* /var/lib/log/* /tmp/* /var/tmp/*

WORKDIR /
EXPOSE 80
EXPOSE 443
