FROM debian:bullseye-slim As builder

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

FROM scratch

LABEL maintainer="BecodReyes <i@muir.fun>"

COPY --from=builder /socat /

CMD ["/socat", "-h"]