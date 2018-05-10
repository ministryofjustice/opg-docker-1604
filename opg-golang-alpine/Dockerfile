FROM golang:alpine

COPY docker/go-wrapper /usr/local/bin/

ENV PATH="/go/bin:/usr/local/go/bin:$PATH" \
    GOPATH="/go"                           \
    OPG_SERVICE="golang"

RUN apk --no-cache add git   &&\
    mkdir -p /go/src /go/bin &&\
    chmod -R 777 /go         &&\
    go get -u github.com/golang/dep/cmd/dep

WORKDIR /go
