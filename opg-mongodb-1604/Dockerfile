FROM registry.service.opg.digital/opg-base-1604:0.0.2-alpha

COPY docker/. /

ENV MONGODB_VERSION="3.0.15" \
    OPG_SERVICE="mongodb"    \
    MONGO_STORAGE_ENGINE_CACHESIZEGB="1"

RUN wget -qO - https://docs.mongodb.org/10gen-gpg-key.asc | apt-key add - &&\
    echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse" > /etc/apt/sources.list.d/mongodb-org.list &&\
    apt-get update &&\
    apt-get install -y python-paramiko  \
                       python-gobject-2 \
                       python-openssl   \
                       backupninja      \
                       duplicity        \
                       mongodb-org=${MONGODB_VERSION} &&\
    chmod a+x /etc/sv/mongod/run                      &&\
    ln -s /etc/sv/mongod /etc/service/                &&\
    mkdir -p /data/mongodb                            &&\
    chown -R mongodb:mongodb /data/mongodb            &&\
    sed -i 's/\/var\/log\/syslog/\/var\/log\/backupninja.log/g' /etc/backupninja.conf

VOLUME /data/mongodb
EXPOSE 27017
