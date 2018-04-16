FROM registry.service.opg.digital/opg-base-1604:0.0.2-alpha

COPY docker/. /
ENV KIBANA_VERSION="5.4.0" \
    ES_SKIP_SET_KERNEL_PARAMETERS="true" \
    ELASTICSEARCH_REPO_BASE="https://artifacts.elastic.co/packages/5.x/apt" \
    PORT="5601"    \
    HOST="0.0.0.0" \
    ELASTICSEARCH="elasticsearch" \
    ELASTICSEARCH_PORT_9200_TCP="9200" \
    ELASTICSEARCH_PRESERVE_HOST="true" \
    KIBANA_INDEX=".kibana"    \
    DEFAULT_APP_ID="discover" \
    REQUEST_TIMEOUT="300000"  \
    SHARD_TIMEOUT="0"         \
    VERIFY_SSL="true"         \
    OPG_SERVICE="kibana"

RUN groupadd -r kibana          &&\
    useradd -r -g kibana kibana &&\
    wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -                  &&\
    echo "deb ${ELASTICSEARCH_REPO_BASE} stable main" > /etc/apt/sources.list.d/elasticsearch.list &&\
    apt-get update -qq                       &&\
    apt-get install kibana=${KIBANA_VERSION} &&\
    rm -rf /var/lib/apt/lists/*              &&\
    chmod a+x /etc/sv/kibana/run             &&\
    ln -s /etc/sv/kibana /etc/service/

EXPOSE 5601
