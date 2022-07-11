FROM golang:1.18 AS build

RUN apt-get update \
 && apt-get install git -y \
 && git clone --depth 1 https://github.com/LouisYLWang/Sync-Sofa /build \
 && cd /build/server \
 && export GO111MODULE=on \
 && CGO_ENABLED=0 go build -a -ldflags '-extldflags "-static"' \
 && chmod +x ./server

FROM alpine:3.15
RUN apk add --no-cache ca-certificates
COPY --from=build /build/server/server /server

EXPOSE 443
ENTRYPOINT ["/server"]
