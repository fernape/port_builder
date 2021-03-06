#! /usr/local/bin/bash

source config.sh

MSG=${1}
CHATID="$(cat "${TG_CHATID_FILE}")"
KEY="$(cat "${TG_KEY_FILE}")"
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"

if [[ $# -ne 1 ]];then
	echo Usage "$0" message
fi

${CURL_BIN} -s --max-time "${TIME}" -d "chat_id=${CHATID}&text=${MSG}" "${URL}" >/dev/null
