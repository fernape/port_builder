#!/usr/local/bin/bash

source config.sh

########################################
# Print build result
# Input: $1 Jail name
#	 $2 build result
# Globals: none
########################################
print_build_result()
{
	local jail_name=${1}
	local build_result=${2}

	if [[ "${build_result}" == "OK"  ]]; then
		echo -e "${jail_name} done [${C_GREEN}OK${C_RESTORE}]"
	else
		echo -e "${jail_name} done [${C_RED}FAILED${C_RESTORE}]"
	fi

}

JAIL_NAME=$1
PORT_NAME=$(cat $SAVED_PORT_FILE)
STATUS_FILE="${JAIL_NAME}"_exit_status
POUDRIERE_CMD="poudriere testport -p default -j ${JAIL_NAME} -o ${PORT_NAME} && touch ${STATUS_FILE}"
WINDOW_TITLE="-T ${PORT_NAME}_[${JAIL_NAME}]"

# Ensure we don't have a status file from a past compilation
rm "${STATUS_FILE}" 2>/dev/null

echo "Building ${PORT_NAME} for ${JAIL_NAME}... "

${TERMINAL_CMD}"${POUDRIERE_CMD}"" ${WINDOW_TITLE}"

ret_str="FAILED"

if [[ -f ${STATUS_FILE} ]]; then
	ret_str="OK"
fi

print_build_result "${JAIL_NAME}" "${ret_str}"

./notify.sh "${PORT_NAME} build on ${JAIL_NAME} finished [$ret_str]" &> /dev/null

rm ${STATUS_FILE} 2>/dev/null

