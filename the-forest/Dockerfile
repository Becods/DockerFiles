FROM debian:bullseye-slim

LABEL Maintainer "Becods <i@muir.fun>"

ARG DEBIAN_FRONTEND=noninteractive

ENV	DISPLAY=:0 \
	TTYD_PORT=7681 \
	TZ="Asia/Shanghai" \
	STEAMCMDDIR="/usr/share/steamcmd" \
	STEAMAPP=The-Forest \
	STEAMAPPID=556450 \
    STEAMAPPDIR="/${STEAMAPP}-dedicated" \
    WINEARCH=win64

RUN set -x \
# && echo "deb http://mirrors.tencent.com/debian bullseye main" > /etc/apt/sources.list \
 && dpkg --add-architecture i386 \
 && apt update \
 && apt-get install -y --no-install-recommends --no-install-suggests \
		lib32stdc++6 lib32gcc-s1 wget ca-certificates \
		libsdl2-2.0-0:i386 lib32z1 screen procps \
		lib32z1 tzdata procps screen xvfb wine wine32 wine64 \
 && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
 && echo $TZ > /etc/timezone \
 && mkdir -p "${STEAMCMDDIR}" \
 && wget -O- 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar xvzf - -C "${STEAMCMDDIR}" \
 && "${STEAMCMDDIR}/steamcmd.sh" +quit \
 && ln -s "${STEAMCMDDIR}/linux32/steamclient.so" "/usr/lib/i386-linux-gnu/steamclient.so" \
 && ln -s "${STEAMCMDDIR}/linux64/steamclient.so" "/usr/lib/x86_64-linux-gnu/steamclient.so" \
 && apt remove --purge -y wget \
 && apt clean autoclean \
 && apt autoremove -y \
 && rm -rf /var/lib/apt/lists/*

ENV FDS_CONFIG_PATH="/data/config" \
    FDS_CONFIG_FILE="config.cfg" \
    FDS_SAVE_PATH="/data/saves" \
	ADDITIONAL_ARGS=""

EXPOSE 8766/tcp 8766/udp 27015/tcp 27015/udp 27016/tcp 27016/udp

ADD https://github.com/tsl0922/ttyd/releases/download/latest/ttyd.x86_64 /ttyd
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x "/entrypoint.sh" \
 && chmod +x "/ttyd"

WORKDIR ${STEAMAPPDIR}

ENTRYPOINT ["/entrypoint.sh"]

CMD ["dl"]
