FROM debian:bullseye-slim

LABEL Maintainer "Becod <i@Muir.fun>"

ARG DEBIAN_FRONTEND=noninteractive

ENV	VNC_PASS="samplepass" \
	VNC_TITLE="Chrome" \
	VNC_RESOLUTION="1280x720" \
	DISPLAY=:0 \
	PORT=6800 \
	LANG=zh_CN.UTF-8 \
	LANGUAGE=zh_CN.UTF-8 \
	LC_ALL=C.UTF-8 \
	TZ="Asia/Shanghai"

RUN	apt update \
 && apt install --no-install-recommends -y python3-minimal websockify xvfb x11vnc procps supervisor fluxbox gnupg git wget tzdata ca-certificates xfonts-base fonts-wqy-microhei \
 && wget -qO - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
 && echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
 && apt update \
 && apt install --no-install-recommends -y google-chrome-stable \
 && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
 && echo $TZ > /etc/timezone \
 && git clone --depth 1 https://github.com/novnc/noVNC /var/noVNC \
 && ln -s /var/noVNC/vnc_auto.html /var/noVNC/index.html \
 && rm -rf /var/noVNC/.git \
 && openssl req -new -newkey rsa:2048 -days 36500 -nodes -x509 -subj "/C=CN/ST=VNC/L=VNC/O=VNC/CN=VNC" -keyout /etc/ssl/novnc.key  -out /etc/ssl/novnc.cert \
 && apt autoremove git -y \
 && apt clean \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/* \
 && mkdir -p ~/.fluxbox/ \
 && echo "session.screen0.toolbar.tools: iconbar \
session.screen0.toolbar.autoHide: false \
session.screen0.toolbar.visible: false \
" > ~/.fluxbox/init

EXPOSE 6800

COPY supervisiord.conf /supervisord.conf

ENTRYPOINT ["supervisord", "-l", "/var/log/supervisord.log", "-c"]

CMD ["/supervisord.conf"]
