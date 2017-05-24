FROM registry.service.opg.digital/opg-base-1604

RUN  apt update && apt install -y postfix && \
     apt clean && apt -y autoremove && \
     rm -rf /var/lib/cache/* /var/lib/log/* /tmp/* /var/tmp/*

ADD  docker/confd /etc/confd

ADD  docker/service/postfix /etc/service/postfix
RUN  chmod a+x /etc/service/postfix/run

ADD  docker/postfix /etc/postfix

VOLUME /var/spool/postfix

# postfix-stats
RUN  pip install git+https://github.com/ministryofjustice/postfix-stats-collector.git#egg=postfix-stats-collector
ADD  docker/syslog-ng /etc/syslog-ng
ADD  docker/service/postfix-stats-qshape /etc/service/postfix-stats-qshape
RUN  chmod a+x /etc/service/postfix-stats-qshape/run

# copy init scripts
ADD  docker/my_init.d /etc/my_init.d
RUN  chmod a+x /etc/my_init.d/*

ENV  SSMTP_DOMAIN_FROM from.example.com
ENV  SSMTP_DOMAIN_TO to.example.com
ENV  STATSD_HOST localhost
ENV  STATSD_PORT 8125
ENV  STATSD_DELAY 10

ENV  OPG_SERVICE ssmtp
