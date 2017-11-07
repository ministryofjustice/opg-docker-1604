FROM golang:alpine

ARG GOLANG_VERSION=1.9.2

RUN apk update && \
    apk add git && \
    mkdir -p /go/src /go/bin && \
    chmod -R 777 /go

COPY docker/go-wrapper /usr/local/bin/

ENV PATH="/go/bin:/usr/local/go/bin:$PATH" GOPATH="/go"
WORKDIR /go

RUN go get -u github.com/golang/dep/cmd/dep

ENV OPG_SERVICE golang
