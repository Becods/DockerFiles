FROM debian:bullseye-slim As clone

RUN apt-get update \
 && apt-get install git -y \
 && git clone https://github.com/lkeme/bilibili-pcheartbeat /bilibili-pcheartbeat

FROM node:slim

LABEL maintainer="BecodReyes <i@muir.fun>"

COPY --from=clone /bilibili-pcheartbeat /app

WORKDIR /app

RUN npm install

CMD ["/usr/local/bin/node","/app/app.js"]