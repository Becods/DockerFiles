FROM golang:1.18-alpine as builder
ENV WEBDAV_VERSION 4.2.0

RUN apk --update add ca-certificates git wget \
 && mkdir -p /rootfs/etc/ssl/certs \
 && cp /etc/ssl/certs/ca-certificates.crt /rootfs/etc/ssl/certs/ca-certificates.crt \
 && git clone -b v${WEBDAV_VERSION} --depth 1 https://github.com/hacdias/webdav \
 && cd webdav \
 && go get -v -t -d ./... \
 && CGO_ENABLED=0 go build -o /rootfs/webdav -trimpath -ldflags '-s -w -buildid=' .

FROM scratch
LABEL maintainer="BecodReyes <i@muir.fun>"

COPY --from=builder /rootfs /

EXPOSE 80

ENTRYPOINT ["/webdav"]