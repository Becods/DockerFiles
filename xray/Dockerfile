FROM golang:1.18 as builder
ENV XRAY_VERSION 1.5.5

RUN apt-get install -y git wget \
 && mkdir -p /rootfs/usr/share/xray/ \
 && mkdir -p /rootfs/var/log/xray/ \
 && mkdir -p /rootfs/etc/xray \
 && git clone -b v${XRAY_VERSION} --depth 1 https://github.com/XTLS/Xray-core \
 && cd Xray-core \
 && go mod download \
 && CGO_ENABLED=0 go build -o /rootfs/xray -trimpath -ldflags '-s -w -buildid=' ./main \
 && echo '{}' > /rootfs/etc/xray/config.json \
 && wget -O /rootfs/usr/share/xray/geosite.dat https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat \
 && wget -O /rootfs/usr/share/xray/geoip.dat https://github.com/v2fly/geoip/releases/latest/download/geoip.dat

FROM alpine:3
LABEL maintainer="BecodReyes <i@muir.fun>"

COPY --from=builder /rootfs /

ENV XRAY_LOCATION_ASSET=/usr/share/xray/ XRAY_LOCATION_CONFIG=/etc/xray/

RUN ln -sf /dev/stdout /var/log/xray/access.log \
 && ln -sf /dev/stderr /var/log/xray/error.log

ENTRYPOINT ["/usr/bin/xray"]

STOPSIGNAL SIGQUIT

CMD ["run"]