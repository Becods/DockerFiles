FROM alpine/git AS git
ENV READER_VERSION v2.5.4
COPY patch /patch
RUN git clone --depth 1 -b $READER_VERSION https://github.com/hectorqin/reader /app \
 && cd /app \
 && git apply /patch

FROM node:16 AS build-web
COPY --from=git /app/web /app/web
RUN cd /app/web \
 && yarn && yarn build

FROM gradle:7-jdk11 AS build-jar
COPY --from=git /app/ /app/
COPY --from=build-web /app/web/dist /app/src/main/resources/web
RUN cd /app \
 && rm src/main/java/com/htmake/reader/ReaderUIApplication.kt \
 && gradle -b cli.gradle assemble --info \
 && mv ./build/libs/*.jar ./build/libs/reader.jar

FROM azul/zulu-openjdk-alpine:17-jre
ENV TZ=Asia/Shanghai
RUN apk add --no-cache ca-certificates tini tzdata \
 && update-ca-certificates \
 && rm -rf /var/cache/apk/*
COPY --from=build-jar /app/build/libs/reader.jar /app/bin/reader.jar
EXPOSE 8080
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["java", "-jar", "/app/bin/reader.jar" ]
