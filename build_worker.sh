#!/usr/local/bin/bash

source config.sh
source common.sh

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

################################################################
# Upload generated logs
# Input: None
# Output: None
# Globals: PORT_NAME, LOGS_BASE, JAIL_NAME, PORTS_COLLECTION
################################################################
upload_logs()
{
	local upload_dir
	local port_name
	local port_version
	local logs_dir

	upload_dir=$(get_canonical_port_name "${PORT_NAME}")
	port_name=$(echo "${upload_dir}" | cut -f1 -d'-')
	port_version=$(echo "${upload_dir}" | cut -f2 -d'-')
	logs_dir="${LOGS_BASE}/${port_name}/${port_version}"

	./db_upload_file.sh "${logs_dir}/${JAIL_NAME}-${PORTS_COLLECTION}.log" "${upload_dir}" &>/dev/null
}

JAIL_NAME=$1
PORT_NAME=$(head -n1 "$SAVED_PORT_FILE")
STATUS_FILE="${JAIL_NAME}"_exit_status
POUDRIERE_CMD="poudriere testport -p ${PORTS_COLLECTION} -j ${JAIL_NAME} -o ${PORT_NAME} && touch ${STATUS_FILE}"
WINDOW_TITLE="-T ${PORT_NAME}_[${JAIL_NAME}]"

# Ensure we don't have a status file from a past compilation
rm "${STATUS_FILE}" 2>/dev/null

echo "Building ${PORT_NAME} for ${JAIL_NAME}... "

${TERMINAL_CMD}"${POUDRIERE_CMD}"" ${WINDOW_TITLE}"

ret_str="FAILED"

if [[ -f ${STATUS_FILE} ]]; then
	ret_str="OK"
fi

upload_logs
print_build_result "${JAIL_NAME}" "${ret_str}"

./notify.sh "${PORT_NAME} build on ${JAIL_NAME} finished [$ret_str]" &> /dev/null

rm "${STATUS_FILE}" 2>/dev/null

