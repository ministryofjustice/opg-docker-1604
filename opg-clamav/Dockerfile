FROM alpine:3.6

RUN apk add --no-cache clamav clamav-libunrar

RUN wget -O /var/lib/clamav/main.cvd http://database.clamav.net/main.cvd && \
  wget -O /var/lib/clamav/daily.cvd http://database.clamav.net/daily.cvd && \
  wget -O /var/lib/clamav/bytecode.cvd http://database.clamav.net/bytecode.cvd && \
  chown clamav:clamav /var/lib/clamav/*.cvd

COPY clamd.conf freshclam.conf /etc/clamav/

# Expose the ports for clamd
EXPOSE 3310

VOLUME ["/var/lib/clamav"]
CMD ["clamd"]
