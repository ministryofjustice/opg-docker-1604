FROM alpine:3.4

RUN apk add --no-cache \
  clamav \
  clamav-libunrar \
  freshclam \
  openrc \
  dcron

RUN wget -O /var/lib/clamav/main.cvd http://database.clamav.net/main.cvd && \
  wget -O /var/lib/clamav/daily.cvd http://database.clamav.net/daily.cvd && \
  wget -O /var/lib/clamav/bytecode.cvd http://database.clamav.net/bytecode.cvd && \
  chown clamav:clamav /var/lib/clamav/*.cvd

COPY clamd.conf freshclam.conf /etc/clamav/

# Run freshclam every hour
RUN echo '03 * * * * freshclam' >> /etc/crontabs/root

# Expose the ports for clamd
EXPOSE 3310

CMD ["clamd"]
