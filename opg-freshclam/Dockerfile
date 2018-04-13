FROM alpine:3.6

RUN apk add --no-cache clamav-libunrar freshclam

# Run freshclam every hour
RUN echo '03 * * * * freshclam' >> /etc/crontabs/root

CMD ["/usr/sbin/crond", "-f", "-d", "8"]
