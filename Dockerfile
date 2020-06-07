FROM golang:1.11.2-alpine3.8
LABEL maintainer "vivek.lanjekar@gmail.com"

ENV INFLUXDB_URL=http://monitoring-influxdb:8086/
ENV INFLUXDB_DATABASE=prometheus
ENV INFLUXDB_RETENTION_POLICY=autogen

EXPOSE 9201

COPY run.sh /

RUN apk add --no-cache git && \
    mkdir -p /go/src/github.com/prometheus && \
    cd /go/src/github.com/prometheus && \
    git clone --branch v2.2.1 --depth 1 https://github.com/prometheus/prometheus.git && \
    go get -d -v /go/src/github.com/prometheus/prometheus/documentation/examples/remote_storage/remote_storage_adapter && \
    go install -v /go/src/github.com/prometheus/prometheus/documentation/examples/remote_storage/remote_storage_adapter && \
    cd / && \
    apk del git && \
    rm -rf /go/src/github.com /var/cache/apk && \
    chmod +x /run.sh

CMD ["/run.sh"]
