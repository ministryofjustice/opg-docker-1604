FROM alpine:3.8

RUN apk --update add --no-cache \
    # Script runs in bash
    bash \
    # Need Gnu date
    coreutils \ 
    curl
  
ADD docker/opt /opt