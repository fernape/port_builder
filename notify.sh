#! /usr/local/bin/bash

TG_BIN="$(whereis -q telegram-cli)"
TO=${1}
MSG=${2}
PUB_KEY=/usr/local/etc/telegram-cli/server.pub

if [[ $# -ne 2 ]];then
	echo Usage $0 destination_peer message
fi

${TG_BIN} -Wk ${PUB_KEY} -e "msg ${TO} \"${MSG}\""

#telegram-cli -W -e "msg Fernando_Apesteguia_Santiago Build finished OK"
