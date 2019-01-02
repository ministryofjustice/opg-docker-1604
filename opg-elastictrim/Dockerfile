FROM alpine:3.8

RUN apk --update add --no-cache \
    # Script runs in bash
    bash \
    # Need Gnu date
    coreutils \ 
    curl \
    docker \
    openrc

# Start docker on boot
RUN rc-update add docker boot
  
ADD docker/opt /opt