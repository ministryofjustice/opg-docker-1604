FROM registry.service.opg.digital/opg-base-1604

# Download and install wkhtmltopdf
RUN apt update && \
    apt install -y gdebi && \
    cd /tmp && \
    wget https://downloads.wkhtmltopdf.org/0.12/0.12.2.1/wkhtmltox-0.12.2.1_linux-wheezy-amd64.deb && \
    gdebi -n -q wkhtmltox-0.12.2.1_linux-wheezy-amd64.deb && \
    rm -rf /var/lib/cache/* /var/lib/log/* /tmp/* /var/tmp/* && \
    pip install werkzeug executor gunicorn

ADD app.py /app.py

EXPOSE 80

ENTRYPOINT ["usr/local/bin/gunicorn"]

# Show the extended help
CMD ["-b", "0.0.0.0:80", "--log-file", "-", "app:application"]

