FROM phusion/baseimage:0.10.2

ENV HOME="/root"                     \
    DEBIAN_FRONTEND="noninteractive" \
    LANG="en_GB.UTF-8"               \
    LANGUAGE="en_GB:en"              \
    LC_ALL="en_GB.UTF-8"             \
    OPG_SERVICE="base"               \
    BEAVER_VERSION="36.2.1"          \
    CONFD_VERSION="0.15.0"           \
    GOSU_VERSION="1.10"

COPY docker/. /

RUN locale-gen en_GB en_GB.UTF-8 &&\
    echo "Installing Gosu" &&\
    gpg --keyserver hkp://ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 &&\
    curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture)" &&\
    curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture).asc" &&\
    gpg --verify /usr/local/bin/gosu.asc &&\
    rm /usr/local/bin/gosu.asc &&\
    chmod +x /usr/local/bin/gosu

RUN echo "Updating Packages" &&\
    apt-get update -qq &&\
    apt-get install -y dos2unix \
    git \
    python-setuptools \
    python \
    python-pip \
    wget \
    dnsmasq \
    unzip \
    zip \
    netcat \
    netcat-traditional \
    iproute2 \
    sudo &&\
    echo "Installing log aggregation and AWSCLI" &&\
    pip install -U pip==9.0.3 &&\
    pip install -q awscli Beaver==${BEAVER_VERSION} &&\
    mkdir -p /etc/beaver.d &&\
    chmod a+x /etc/sv/beaver/run  && ln -s /etc/sv/beaver  /etc/service/   &&\
    chmod a+x /etc/sv/dnsmasq/run && ln -s /etc/sv/dnsmasq /etc/service/ &&\
    add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -sc)-pgdg main" &&\
    wget -q -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - &&\
    apt-get update -y &&\
    apt-get install -y postgresql-client-9.6 &&\
    psql --version | grep 9.6 &&\
    apt-get clean && rm -rf /tmp/* /var/tmp/* && rm -rf /var/lib/apt/lists/*

RUN echo "Installing ConfD" &&\
    curl -o /usr/bin/confd -SL "https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64" &&\
    chmod a+x /usr/bin/confd &&\
    mkdir -p /etc/confd/conf.d /etc/confd/templates &&\
    echo "Disabling ssh access" &&\
    rm /etc/my_init.d/00_regen_ssh_host_keys.sh &&\
    rm -rf /etc/service/sshd || true &&\
    echo "Application user and location" &&\
    useradd -m -d /app app &&\
    mkdir -p /var/log/app /data /var/run/app &&\
    chown app /var/log/app /data /var/run/app &&\
    echo "Providing a resolver at localhost for software that can't/won't use /etc/resolv.conf" &&\
    chmod a+x /etc/service/dnsmasq/run &&\
    echo "Disabling MTU on vixie cron" &&\
    chmod 600 /var/spool/cron/crontabs/root &&\
    chmod 600 /var/spool/cron/crontabs/app &&\
    chown app:crontab /var/spool/cron/crontabs/app && \
    chmod a+x /etc/my_init.d/* &&\
    chmod -R a+x /scripts/base
