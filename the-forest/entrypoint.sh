#!/bin/bash
if [ ! -d $FDS_SAVE_PATH ];then
	mkdir -p $FDS_SAVE_PATH
fi
if [ ! -d $FDS_CONFIG_PATH ];then
	mkdir -p $FDS_CONFIG_PATH
fi
chmod +x /ttyd
if [[ $1 == "dl" ]];then
	"${STEAMCMDDIR}/steamcmd.sh" \
		+login anonymous \
		+force_install_dir "${STEAMAPPDIR}" \
		+app_update "${STEAMAPPID}" \
		+quit
elif [[ $1 == "daemon" ]];then
	sleep 10
	while true;do
        if [[ -z `ps -aux|grep "${STEAMAPP}"|grep "game"` ]];then
			kill -9 $(ps aux | grep 'ttyd' | awk '{print $2}')
		fi
		sleep 3
	done
elif [[ $1 == "X11" ]];then
	Xvfb $DISPLAY -screen 0 $VNC_RESOLUTION"x24" -nolisten unix
elif [[ $1 == "game" ]];then
	wine64 `winepath -w "${STEAMAPPDIR}/TheForestDedicatedServer.exe" 2>/dev/null` \
		-dedicated \
		-batchmode \
		-nographics \
		-nosteamclient \
		-savefolderpath `winepath -w "$FDS_SAVE_PATH" 2>/dev/null` \
		-configfilepath `winepath -w "${FDS_CONFIG_PATH}/${FDS_CONFIG_FILE}" 2>/dev/null` \
		"${ADDITIONAL_ARGS}"
else
	sed -i "s/sleep 1/#sleep 1/g" "${STEAMAPPDIR}/srcds_run"
	screen -dmUS X11 bash entrypoint.sh X11
	screen -dmUS daemon bash entrypoint.sh daemon
	screen -dmUS $STEAMAPP bash entrypoint.sh game
	/ttyd -t titleFixed=$STEAMAPP -t disableReconnect=true -t scrollback=50000 screen -dUR $STEAMAPP
fi
