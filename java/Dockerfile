FROM gitpod/workspace-full-vnc

USER root

RUN apt-get update -qq \
 && apt-get install -y java-common libxtst6 \
 && cd /tmp \
 && wget https://cdn.azul.com/zulu/bin/zulu18.30.11-ca-jdk18.0.1-linux_amd64.deb \
 && wget https://cdn.azul.com/zulu/bin/zulu17.34.19-ca-jdk17.0.3-linux_amd64.deb \
 && wget https://cdn.azul.com/zulu/bin/zulu11.56.19-ca-jdk11.0.15-linux_amd64.deb \
 && wget https://cdn.azul.com/zulu/bin/zulu8.62.0.19-ca-jdk8.0.332-linux_amd64.deb \
 && wget https://cdn.azul.com/zulu/bin/zulu7.54.0.13-ca-jdk7.0.342-linux_amd64.deb \
 && dpkg -i zulu17.34.19-ca-jdk17.0.3-linux_amd64.deb \
 && dpkg -i zulu17.34.19-ca-jdk17.0.3-linux_amd64.deb \
 && dpkg -i zulu11.56.19-ca-jdk11.0.15-linux_amd64.deb \
 && dpkg -i zulu8.62.0.19-ca-jdk8.0.332-linux_amd64.deb \
 && dpkg -i zulu7.54.0.13-ca-jdk7.0.342-linux_amd64.deb \
 && apt clean -qq

USER gitpod