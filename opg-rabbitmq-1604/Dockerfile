FROM registry.service.opg.digital/opg-base-1604

ENV RABBITMQ_LOGS=- RABBITMQ_SASL_LOGS=-

RUN groupadd -r rabbitmq && \
    useradd -r -d /var/lib/rabbitmq -m -g rabbitmq rabbitmq && \
    wget -O- https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | apt-key add - && \
    echo 'deb http://packages.erlang-solutions.com/debian wheezy contrib' > /etc/apt/sources.list.d/erlang.list && \
    wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | apt-key add - && \
    echo 'deb http://www.rabbitmq.com/debian/ testing main' > /etc/apt/sources.list.d/rabbitmq.list && \
    apt update && \
    apt install -y rabbitmq-server && \
    rm -rf /var/lib/apt/lists/*

# /usr/sbin/rabbitmq-server has some irritating behavior, and only exists to "su - rabbitmq /usr/lib/rabbitmq/bin/rabbitmq-server ..."
ENV PATH /usr/lib/rabbitmq/bin:$PATH

VOLUME /var/lib/rabbitmq

# Provide default values for confd
ENV HOME /var/lib/rabbitmq
ENV RABBITMQ_TCP_LISTENERS 5672
ENV RABBITMQ_DEFAULT_VHOST /rabbitmq
ENV RABBITMQ_DEFAULT_USER rabbitmq
ENV RABBITMQ_DEFAULT_PASS rabbitmq
ENV RABBITMQ_SSL true
ENV RABBITMQ_SSL_LISTENERS 5671
ENV RABBITMQ_SSL_CERTFILE '/etc/ssl/cert.pem'
ENV RABBITMQ_SSL_KEYFILE '/etc/ssl/key.pem'
ENV RABBITMQ_SSL_VERIFY verify_none
ENV RABBITMQ_SSL_NOPEER false

ADD docker/confd /etc/confd

ADD docker/service/rabbitmq /etc/sv/rabbitmq
RUN chmod a+x /etc/sv/rabbitmq/run
RUN  ln -s /etc/sv/rabbitmq /etc/service/

ENV OPG_SERVICE rabbitmq
