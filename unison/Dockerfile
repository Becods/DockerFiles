FROM debian:bullseye-slim as builder

RUN echo "deb http://deb.debian.org/debian bullseye main" > /etc/apt/sources.list \
 && apt-get update \
 && apt-get -y install git curl build-essential opam

RUN git clone https://github.com/bcpierce00/unison /unison \
 && cd /unison \
 && echo $UNISON_VERSION \
 && git checkout $UNISON_VERSION \
 && make STATIC=true

FROM scratch
LABEL maintainer="BecodReyes <i@muir.fun>"

COPY --from=builder /unison/src/unison* /usr/local/bin/

ENTRYPOINT ["unison"]
CMD ["-doc", "about"]
