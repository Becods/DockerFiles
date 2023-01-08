FROM alpine:edge

RUN apk add --no-cache tftp-hpa

VOLUME ["/var/tftproot"]
EXPOSE 69/udp
CMD ["sh", "-c", "busybox syslogd; in.tftpd -Lvvv --secure /var/tftp"]