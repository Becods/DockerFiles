#!/bin/bash

command="$@"

init(){
    echo "$0: 正在初始化..."
    cp -rf /tmp/HoshinoBot /HoshinoBot
    cp -rf /tmp/AI_image_gen /HoshinoBot/hoshino/modules/AI_image_gen
    cd /HoshinoBot
    cp -r hoshino/config_example hoshino/config
    cp -r hoshino/modules/config.template.json hoshino/modules/config.json
    echo "$0: 初始化完成!"
    exec $command
}

if [[ ! "$(ls -A /HoshinoBot)" ]]; then
    init
else
    cd /HoshinoBot
    exec $command
fi
