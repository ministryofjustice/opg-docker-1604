FROM registry.service.opg.digital/opg-base-1604:0.0.2-alpha

COPY docker/. /
RUN apt-get update -qq &&\
    apt-get install -y postfix &&\
    rm -rf /var/lib/cache/* /var/lib/log/* /tmp/* /var/tmp/* &&\
    pip install git+https://github.com/ministryofjustice/postfix-stats-collector.git#egg=postfix-stats-collector &&\
    chmod a+x /etc/service/postfix/run &&\
    chmod a+x /etc/service/postfix-stats-qshape/run &&\
    chmod a+x /etc/my_init.d/*

VOLUME /var/spool/postfix

ENV SSMTP_DOMAIN_FROM="from.example.com" \
    SSMTP_DOMAIN_TO="to.example.com" \
    STATSD_HOST="localhost" \
    STATSD_PORT="8125" \
    STATSD_DELAY="10" \
    OPG_SERVICE="ssmtp"
