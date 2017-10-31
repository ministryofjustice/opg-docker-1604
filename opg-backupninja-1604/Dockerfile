FROM registry.service.opg.digital/opg-base-1604

RUN apt  update && \
    apt install -y duplicity \
                   python-paramiko \
                   python-gobject-2 \
                   backupninja && \
    apt clean -y && \
    apt autoremove -y


ADD docker/etc /etc
ADD docker/usr /usr
ADD docker/confd /etc/confd
ADD docker/my_init /etc/my_init.d

ENV OPG_SERVICE backupninja