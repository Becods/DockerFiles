FROM golang:1.18-alpine AS building

ENV DRONE_VERSION v2.12.1

RUN apk add -U --no-cache ca-certificates git build-base \
 && git clone -b $DRONE_VERSION https://github.com/harness/drone /drone \
 && cd /drone \
 && go test ./... \
 && go build -ldflags "-extldflags \"-static\"" -tags "nolimit" -o drone-server ./cmd/drone-server

FROM alpine:3
EXPOSE 80 443
VOLUME /data

RUN [ ! -e /etc/nsswitch.conf ] && echo 'hosts: files dns' > /etc/nsswitch.conf

ENV GODEBUG netdns=go
ENV XDG_CACHE_HOME /data
ENV DRONE_DATABASE_DRIVER sqlite3
ENV DRONE_DATABASE_DATASOURCE /data/database.sqlite
ENV DRONE_RUNNER_OS=linux
ENV DRONE_RUNNER_ARCH=amd64
ENV DRONE_SERVER_PORT=:80
ENV DRONE_SERVER_HOST=localhost
ENV DRONE_DATADOG_ENABLED=true
ENV DRONE_DATADOG_ENDPOINT=https://stats.drone.ci/api/v1/series

COPY --from=building /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=building /drone/drone-server /bin/

ENTRYPOINT ["/bin/drone-server"]