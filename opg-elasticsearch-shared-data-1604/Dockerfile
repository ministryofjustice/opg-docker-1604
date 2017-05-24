FROM alpine

RUN mkdir -p /tmp/elasticsearchshareddata/beats

ENV BEATS_DASHBOARD_VERSION=5.4.0

#Needed to allow us to download from the es site
RUN apk update && \
    apk add --no-cache ca-certificates wget openssl && \
    update-ca-certificates && \cd /tmp && \
    wget https://artifacts.elastic.co/downloads/beats/beats-dashboards/beats-dashboards-${BEATS_DASHBOARD_VERSION}.zip && \
    unzip beats-dashboards-${BEATS_DASHBOARD_VERSION}.zip && \
    cd /tmp/beats-dashboards-${BEATS_DASHBOARD_VERSION} && \
    cp -rv metricbeat/* /tmp/elasticsearchshareddata/beats && \
    cp -rv filebeat/* /tmp/elasticsearchshareddata/beats && \
    rm -rf /tmp/beats-dashboards-* && \
    chmod -R 644 /tmp/elasticsearchshareddata

VOLUME /tmp/elasticsearchshareddata

USER root
ENV  HOME /root


