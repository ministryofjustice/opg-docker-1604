FROM registry.service.opg.digital/opg-base-1604

# Download and install wkhtmltopdf
ENV MAJOR_VERSION=0.12 \
    MINOR_VERSION=2.1
ENV FULL_VERSION=${MAJOR_VERSION}.${MINOR_VERSION} \
    OPG_SERVICE="wkhtmlpdf"

RUN apt-get update -qq &&\
    apt-get install -qq -y gdebi &&\
    cd /tmp &&\
    wget -q https://downloads.wkhtmltopdf.org/${MAJOR_VERSION}/${FULL_VERSION}/wkhtmltox-${FULL_VERSION}_linux-wheezy-amd64.deb &&\
    echo "f8f376c7939ae7affda39fdd48aa5db2 wkhtmltox-${FULL_VERSION}_linux-wheezy-amd64.deb" | md5sum -c - &&\
    gdebi -n -q wkhtmltox-${FULL_VERSION}_linux-wheezy-amd64.deb &&\
    rm -rf /var/lib/cache/* /var/lib/log/* /tmp/* /var/tmp/* &&\
    pip install werkzeug executor gunicorn

COPY app.py /app.py

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/gunicorn"]

# Show the extended help
CMD ["-b", "0.0.0.0:80", "--log-file", "-", "app:application"]
