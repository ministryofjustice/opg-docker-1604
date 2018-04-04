FROM golang:alpine

RUN apk update               &&\
    apk add git              &&\
    mkdir -p /go/src /go/bin &&\
    chmod -R 777 /go

COPY docker/go-wrapper /usr/local/bin/

ENV PATH="/go/bin:/usr/local/go/bin:$PATH" \
    GOPATH="/go"                           \
    OPG_SERVICE="golang"

WORKDIR /go
RUN go get -u github.com/golang/dep/cmd/dep
