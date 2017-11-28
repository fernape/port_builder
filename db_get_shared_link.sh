#!/usr/local/bin/bash

#################################################
# Input:					#
#	$1 Directory to be shared		#
# Output: The URL with the shared link to $1	#
#################################################

source config.sh

DIR=${1}

curl -s -X POST https://api.dropboxapi.com/2/sharing/create_shared_link_with_settings \
--header "Authorization: Bearer $(cat ${DB_OAUTH_FILE})" \
--header "Content-Type: application/json" \
--data "{\"path\": \"/${DIR}\",\"settings\": {\"requested_visibility\": \"public\"}}"  \
| tr , '\n'  | grep url | cut -f2- -d':' | tr -d ' ' | tr -d '"'
