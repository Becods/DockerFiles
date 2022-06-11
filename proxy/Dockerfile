FROM debian:bullseye-slim As socat-builder

ENV DEBIAN_FRONTEND=noninteractive

ENV MUSL_VERSION 1.2.3
ENV SOCAT_VERSION 1.7.4.3
ENV NCURSES_VERSION 6.3
ENV READLINE_VERSION 8.1
ENV OPENSSL_VERSION 1.1.1n

RUN apt-get update \
 && apt-get upgrade -yy \
 && apt-get install -yy \
    automake \
    build-essential \
    curl \
    git  \
    pkg-config \
    libwrap0-dev \
    linux-libc-dev \
 && apt-get clean

RUN mkdir /build

WORKDIR /build

RUN curl -LO http://invisible-mirror.net/archives/ncurses/ncurses-${NCURSES_VERSION}.tar.gz \
 && tar zxvf ncurses-${NCURSES_VERSION}.tar.gz \
 && cd ncurses-${NCURSES_VERSION} \
 && export CC='/usr/bin/gcc -static' \
 && export CFLAGS='-fPIC' \
 && ./configure \
      --disable-shared \
      --enable-static

RUN curl -LO ftp://ftp.cwru.edu/pub/bash/readline-${READLINE_VERSION}.tar.gz \
 && tar xzvf readline-${READLINE_VERSION}.tar.gz \
 && cd readline-${READLINE_VERSION} \
 && export CC='/usr/bin/gcc -static' \
 && export CFLAGS='-fPIC' \
 && ./configure \
      --disable-shared \
      --enable-static \
 && make -j4 \
 && ln -s /build/readline-${READLINE_VERSION} /build/readline

RUN curl -LO https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz \
 && tar zxvf openssl-${OPENSSL_VERSION}.tar.gz \
 && cd openssl-${OPENSSL_VERSION} \
 && export CC='/usr/bin/gcc -static' \
 && ./Configure no-shared no-async linux-x86_64 \
 && make -j4

RUN curl -LO http://www.dest-unreach.org/socat/download/socat-${SOCAT_VERSION}.tar.gz \
 && tar xzvf socat-${SOCAT_VERSION}.tar.gz \
 && cd socat-${SOCAT_VERSION} \
 && export CC='/usr/bin/gcc -static' \
    export CFLAGS='-fPIC' \
    export CPPFLAGS="-I/build -I/build/openssl-${OPENSSL_VERSION}/include -DNETDB_INTERNAL=-1" \
    export LDFLAGS="-L/build/readline-${READLINE_VERSION} -L/build/ncurses-${NCURSES_VERSION}/lib -L/build/openssl-${OPENSSL_VERSION}" \
 && ./configure \
 && make -j4 \
 && strip socat \
 && cp /build/socat-${SOCAT_VERSION}/socat /socat

FROM golang:1.18 as xray-builder
ENV XRAY_VERSION 1.5.5

RUN apt-get install -y git wget \
 && mkdir -p /rootfs/usr/share/xray/ /rootfs/usr/bin /rootfs/var/log/xray /rootfs/etc/xray \
 && git clone -b v${XRAY_VERSION} --depth 1 https://github.com/XTLS/Xray-core \
 && cd Xray-core \
 && go mod download \
 && CGO_ENABLED=0 go build -o /rootfs/usr/bin/xray -trimpath -ldflags '-s -w -buildid=' ./main \
 && echo '{}' > /rootfs/etc/xray/config.json \
 && wget -O /rootfs/usr/share/xray/geosite.dat https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat \
 && wget -O /rootfs/usr/share/xray/geoip.dat https://github.com/v2fly/geoip/releases/latest/download/geoip.dat

FROM alpine

COPY entrypoint.sh /
COPY --from=socat-builder /socat /usr/bin
COPY --from=xray-builder /rootfs /

ENV XRAY_LOCATION_ASSET=/usr/share/xray/ XRAY_LOCATION_CONFIG=/etc/xray/

RUN ln -sf /dev/stdout /var/log/xray/access.log \
 && ln -sf /dev/stderr /var/log/xray/error.log \
 && chmod +x /entrypoint.sh

LABEL maintainer="BecodReyes <i@muir.fun>"

ENTRYPOINT ["/entrypoint.sh"]
