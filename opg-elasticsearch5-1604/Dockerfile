FROM registry.service.opg.digital/opg-jre8-1604

COPY docker/. /

ENV HOME="/usr/share/elasticsearch" \
    PATH="$HOME/bin:$PATH" \
    OPG_SERVICE="elasticsearch" \
    ELASTICSEARCH_NUMBER_OF_REPLICAS="0" \
    ELASTICSEARCH_NETWORK_BIND_HOST="0.0.0.0" \
    ELASTICSEARCH_SCRIPT_DISABLE_DYNAMIC="true" \
    ELASTICSEARCH_PATH_DATA="/usr/share/elasticsearch/data" \
    ELASTICSEARCH_DISCOVERY_ZEN_MINIMUM_MASTER_NODES="1" \
    ELASTICSEARCH_CLUSTER_NAME="opg" \
    ELASTICSEARCH_CLUSTER_NODES_ONE="elasticsearch" \
    ELASTICSEARCH_NODE_NAME="elasticsearch" \
    ELASTICSEARCH_INDICES_FIELDDATA_CACHE_SIZE="40%" \
    ELASTICSEARCH_GATEWAY_EXPECTED_NODES="1" \
    ELASTICSEARCH_GATEWAY_RECOVER_AFTER_TIME="5m" \
    ELASTICSEARCH_GATEWAY_RECOVER_AFTER_NODES="1" \
    ELASTICSEARCH_CLOUD_AWS_REGION="eu-west-1" \
    ELASTICSEARCH_CLOUD_AWS_S3_PROTOCOL="https" \
    ELASTICSEARCH_CLOUD_AWS_ACCESSKEY="" \
    ELASTICSEARCH_CLOUD_AWS_SECRETKEY="" \
    ELASTICSEARCH_SNAPSHOTS_REPOSITORY_TYPE="s3" \
    ELASTICSEARCH_SNAPSHOTS_REPOSITORY_NAME="snapshot_repo" \
    ELASTICSEARCH_SNAPSHOTS_REPOSITORY_S3_BUCKET="snapshots" \
    ELASTICSEARCH_SNAPSHOTS_REPOSITORY_S3_PATH="/" \
    ELASTICSEARCH_PATH_REPO="/usr/share/elasticsearch/repo" \
    ELASTICSEARCH_SNAPSHOTS_REPOSITORY_FS_PATH="${ELASTICSEARCH_PATH_REPO}/snapshots" \
    ELASTICSEARCH_SNAPSHOTS_RETAIN_DAYS="7" \
    ELASTICSEARCH_REPO_BASE="https://artifacts.elastic.co/packages/5.x/apt" \
    ELASTICSEARCH_VERSION="5.4.0" \
    ES_SKIP_SET_KERNEL_PARAMETERS="true"

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -g 3999 elasticsearch && useradd -m -u 3999 -g 3999 elasticsearch &&\
    wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add - &&\
    echo "deb ${ELASTICSEARCH_REPO_BASE} stable main" > /etc/apt/sources.list.d/elasticsearch.list &&\
    apt update -qq &&\
    apt install -y elasticsearch=${ELASTICSEARCH_VERSION} &&\
    pip install elasticsearch-curator &&\
    rm -rf /var/lib/apt/lists/* &&\
    echo "Setting owner/group on path repo here as if not directory ends up as root:root regardless of later chown/chgrp" &&\
    mkdir -p ${ELASTICSEARCH_PATH_REPO} &&\
    mkdir -p /scripts/elasticsearch $HOME/config/scripts $HOME/logs &&\
    mkdir -p /usr/share/elasticsearch/config &&\
    chown elasticsearch ${ELASTICSEARCH_PATH_REPO} &&\
    chgrp elasticsearch ${ELASTICSEARCH_PATH_REPO} &&\
    chmod a+x /etc/my_init.d/* &&\
    chmod -R a+x /etc/sv/elasticsearch/run &&\
    chmod -R a+x /scripts/elasticsearch &&\
    chmod -R a+x /opt &&\
    ln -s /etc/sv/elasticsearch /etc/service/ &&\
    ln -sf /dev/stdout /var/log/elastic-scripts.log

EXPOSE 9200 9300
VOLUME ${ELASTICSEARCH_PATH_DATA}
VOLUME ${ELASTICSEARCH_PATH_REPO}
