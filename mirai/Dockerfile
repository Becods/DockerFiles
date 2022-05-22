FROM azul/zulu-openjdk:17-jre As dl

ENV MCL_VERSION 2.1.0

RUN apt-get update \
 && apt-get install wget unzip -y \
 && wget -O /tmp/mcl.zip https://github.com/iTXTech/mirai-console-loader/releases/download/v${MCL_VERSION}/mcl-${MCL_VERSION}.zip \
 && unzip -od /tmp/mcl /tmp/mcl.zip

FROM azul/zulu-openjdk:17-jre

ENV TZ Asia/Shanghai

COPY --from=dl /tmp/mcl /app

WORKDIR /app

RUN chmod +x mcl && \
    ./mcl --update-package net.mamoe:mirai-core-all --channel stable &&\
    ./mcl --dry-run

EXPOSE 8080

CMD ["./mcl"]