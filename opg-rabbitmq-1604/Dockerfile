FROM registry.service.opg.digital/opg-base-1604

ENV RABBITMQ_LOGS=- \
    RABBITMQ_SASL_LOGS=-

COPY docker/. /

RUN groupadd -r rabbitmq &&\
    useradd -r -d /var/lib/rabbitmq -m -g rabbitmq rabbitmq &&\
    wget -O- https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | apt-key add - &&\
    wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | apt-key add -         &&\
    apt-get update -qq                     &&\
    apt-get install -qq -y rabbitmq-server &&\
    rm -rf /var/lib/apt/lists/*    &&\
    chmod a+x /etc/sv/rabbitmq/run &&\
    ln -s /etc/sv/rabbitmq /etc/service/

VOLUME /var/lib/rabbitmq

# Provide default values for confd
# /usr/sbin/rabbitmq-server has some irritating behavior, and only exists to "su - rabbitmq /usr/lib/rabbitmq/bin/rabbitmq-server ..."
ENV HOME="/var/lib/rabbitmq" \
    RABBITMQ_TCP_LISTENERS="5672" \
    RABBITMQ_DEFAULT_VHOST="/rabbitmq" \
    RABBITMQ_DEFAULT_USER="rabbitmq" \
    RABBITMQ_DEFAULT_PASS="rabbitmq" \
    RABBITMQ_SSL="true" \
    RABBITMQ_SSL_LISTENERS="5671" \
    RABBITMQ_SSL_CERTFILE="/etc/ssl/cert.pem" \
    RABBITMQ_SSL_KEYFILE="/etc/ssl/key.pem" \
    RABBITMQ_SSL_VERIFY="verify_none" \
    RABBITMQ_SSL_NOPEER="false" \
    PATH="/usr/lib/rabbitmq/bin:${PATH}" \
    OPG_SERVICE="rabbitmq"
