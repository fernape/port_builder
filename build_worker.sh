#!/usr/local/bin/bash

source config.sh

JAIL_NAME=$1
PORT_NAME=$(cat $SAVED_PORT_FILE)
STATUS_FILE=${JAIL_NAME}_exit_status
POUDRIERE_CMD="poudriere testport -p default -j $JAIL_NAME -o $PORT_NAME && touch ${STATUS_FILE}"

# Ensure we don't have a status file from a past compilation
rm ${STATUS_FILE} 2>/dev/null

echo "Building $PORT_NAME for ${JAIL_NAME}... "

${TERMINAL_CMD}"${POUDRIERE_CMD}"

ret_str="${C_RED}FAILED${C_RESTORE}"

if [[ -f ${STATUS_FILE} ]]; then
	ret_str="${C_GREEN}OK${C_RESTORE}"
fi

echo -e "${JAIL_NAME} done [${ret_str}]"
rm ${STATUS_FILE} 2>/dev/null
