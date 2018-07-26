#!/usr/local/bin/bash

#################################################
# Input:					#
#	$1 Path to the file to be uploaded	#
#	$2 Directory to upload $1		#
#################################################

source config.sh

FILE=${1}
DIR=${2}

${CURL_BIN} -X POST https://content.dropboxapi.com/2/files/upload \
--header "Authorization: Bearer $(cat "${DB_OAUTH_FILE}")" \
--header "Dropbox-API-Arg: {\"path\": \"/${DIR}/$(basename "${FILE}")\"}" \
--header "Content-Type: application/octet-stream" --data-binary @"${FILE}"
