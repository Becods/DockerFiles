#!/bin/bash
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
elif [[ $1 == "game" ]];then
	"${STEAMAPPDIR}/srcds_run" -game "${STEAMAPP}" \
		-usercon \
		-tickrate "${SRCDS_TICKRATE}" \
		-port "${SRCDS_PORT}" \
		+tv_port "${SRCDS_TV_PORT}" \
		+clientport "${SRCDS_CLIENT_PORT}" \
		-maxplayers_override "${SRCDS_MAXPLAYERS}" \
		+game_type "${SRCDS_GAMETYPE}" \
		+game_mode "${SRCDS_GAMEMODE}" \
		+mapgroup "${SRCDS_MAPGROUP}" \
		+map "${SRCDS_STARTMAP}" \
		+sv_setsteamaccount "${SRCDS_TOKEN}" \
		+sv_region "${SRCDS_REGION}" \
		+net_public_adr "${SRCDS_NET_PUBLIC_ADDRESS}" \
		-ip "${SRCDS_IP}" \
		+host_workshop_collection "${SRCDS_HOST_WORKSHOP_COLLECTION}" \
		+workshop_start_map "${SRCDS_WORKSHOP_START_MAP}" \
		-authkey "${SRCDS_WORKSHOP_AUTHKEY}" \
		-nomaster \
		"${ADDITIONAL_ARGS}"
else
	sed -i "s/sleep 1/#sleep 1/g" "${STEAMAPPDIR}/srcds_run"
	screen -dmUS daemon bash entrypoint.sh daemon
	screen -dmUS ${STEAMAPP} bash entrypoint.sh game
	/ttyd -t titleFixed=${STEAMAPP} -t disableReconnect=true -t scrollback=50000 screen -dUR ${STEAMAPP}
fi
