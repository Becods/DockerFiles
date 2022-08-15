#!/usr/bin/env sh

if [ "$1" = "server" ]; then
	nohup php -S 0.0.0.0:${PORT} /index.php > /proc/1/fd/1 2>&1 &
	trap "echo stop && killall crond && exit 0" SIGTERM SIGINT 
	crond && while true; do sleep 1; done;
elif [ "$1" = "get" ]; then 
	$@
else 
	exec -- "$@"
fi
