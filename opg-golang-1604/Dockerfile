FROM registry.service.opg.digital/opg-base-1604

ARG GOLANG_VERSION=1.9.2

RUN curl -sSL https://golang.org/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz \
        | tar -v -C /usr/local -xz && \
    mkdir -p /go/src /go/bin && \
    chmod -R 777 /go

COPY docker/go-wrapper /usr/local/bin/

ENV PATH="/go/bin:/usr/local/go/bin:$PATH" GOPATH="/go"
WORKDIR /go

RUN go get -u github.com/golang/dep/cmd/dep

ENV OPG_SERVICE golang
