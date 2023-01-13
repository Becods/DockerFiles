FROM debian:bullseye-slim

LABEL Maintainer "Becods <i@muir.fun>"

ARG DEBIAN_FRONTEND=noninteractive

ENV TTYD_PORT=7681 \
	TZ="Asia/Shanghai" \
	STEAMCMDDIR="/usr/share/steamcmd" \
	STEAMAPPID=740 \
	STEAMAPP=csgo \
    STEAMAPPDIR="/${STEAMAPP}-dedicated"

RUN set -x \
# && echo "deb http://mirrors.tencent.com/debian bullseye main" > /etc/apt/sources.list \
 && dpkg --add-architecture i386 \
 && apt update \
 && apt install -y --no-install-recommends --no-install-suggests \
		lib32stdc++6 lib32gcc-s1 wget ca-certificates \
		libsdl2-2.0-0:i386 lib32z1 screen procps \
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

ENV SRCDS_TICKRATE=128 \
	SRCDS_PORT=27015 \
	SRCDS_TV_PORT=27020 \
	SRCDS_CLIENT_PORT=27005 \
	SRCDS_NET_PUBLIC_ADDRESS="0" \
	SRCDS_IP="0.0.0.0" \
	SRCDS_MAXPLAYERS=14 \
	SRCDS_TOKEN=0 \
	SRCDS_RCONPW="Please-Change-Me-Imitation-Triage7" \
	SRCDS_PW="Please-Change-Me-Overthrow-Footwork2" \
	SRCDS_STARTMAP="de_dust2" \
	SRCDS_REGION=3 \
	SRCDS_MAPGROUP="mg_active" \
	SRCDS_GAMETYPE=0 \
	SRCDS_GAMEMODE=1 \
	SRCDS_HOSTNAME="New \"${STEAMAPP}\" Server" \
	SRCDS_WORKSHOP_START_MAP=0 \
	SRCDS_HOST_WORKSHOP_COLLECTION=0 \
	SRCDS_WORKSHOP_AUTHKEY="" \
	ADDITIONAL_ARGS=""

ADD https://github.com/tsl0922/ttyd/releases/download/latest/ttyd.x86_64 /ttyd
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x "/entrypoint.sh" \
 && chmod +x "/ttyd"

WORKDIR ${STEAMAPPDIR}

ENTRYPOINT ["bash", "/entrypoint.sh"]

CMD ["dl"]
