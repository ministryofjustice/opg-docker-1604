FROM registry.service.opg.digital/opg-base-1604:0.0.2-alpha

COPY docker/. /

ENV OPG_NGINX_SERVER_NAMES="localhost" \
    OPG_SERVICE="nginx"

RUN echo "Compilling nginx"                                      &&\
    . /tmp/compile_nginx.sh                                      &&\
    chmod a+x /etc/sv/nginx/run                                  &&\
    ln -s /etc/sv/nginx /etc/service/                            &&\
    mkdir -p /app/public /etc/nginx/app.conf.d                   &&\
    echo "Hello World from opguk/nginx" > /app/public/index.html

EXPOSE 80
EXPOSE 443
