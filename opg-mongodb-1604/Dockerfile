FROM registry.service.opg.digital/opg-backupninja-1604

ENV MONGODB_VERSION 3.0.15
RUN wget -qO - https://docs.mongodb.org/10gen-gpg-key.asc | apt-key add - && \
    echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse" > /etc/apt/sources.list.d/mongodb-org.list && \
    apt update && \
    apt install -y python-openssl \
                   mongodb-org=${MONGODB_VERSION}

ADD  docker/service/mongod /etc/sv/mongod
RUN  chmod a+x /etc/sv/mongod/run && \
     ln -s /etc/sv/mongod /etc/service/

# Create data volume and change ownership to mongodb user
RUN mkdir -p /data/mongodb

ADD docker/confd /etc/confd
ADD docker/opt /opt
ADD docker/my_init /etc/my_init.d

VOLUME /data/mongodb

EXPOSE 27017

ENV OPG_SERVICE mongodb
ENV MONGO_STORAGE_ENGINE_CACHESIZEGB 1

