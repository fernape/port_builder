#!/usr/local/bin/bash

source config.sh

########################################
# Print available versions
# Input: none
# Output: list of available versions
# Globals: none
########################################
print_versions()
{
	poudriere jails -l | awk '{print $2}' | cut -f1 -d'-' | grep -v VERSION \
		| sort -uh | tr '\n' ' ' | sed -e 's/ $//g'
}

########################################
# Print available architectures
# Input: none
# Output: list of available archs
# Globals: none
########################################
print_archs()
{
	poudriere jails -l | awk '{print $3}' |  grep -v ARCH | sort -u \
		| tr '\n' ' ' | sed -e 's/ $//g'
}

########################################
# Print selected jail names
# Input: $1 version array
#	 $2 archs array
# Output: list of selected jail names
# Globals: SAVED_JAILS_FILE
########################################
save_selected_jails()
{
	local versions=$1
	local archs=$2
	local selected

	local filter=$(echo $versions | sed -e 's/ /|/g')

	for arch in $archs; do
		selected=$(echo $(poudriere jails -l | grep $arch \
			| egrep "$filter" | awk '{print $1;}'))
		echo $selected >> $SAVED_JAILS_FILE
	done
}

########################################
# Cleans up temporary files
# Input: None
# Output: None
# Globals: SAVED_JAILS_FILE
#	   SAVED_PORT_FILE
########################################
cleanup()
{
	rm $SAVED_JAILS_FILE $SAVED_PORT_FILE &> /dev/null
}

########################################
# Request port name to build
# Input: None
# Output: None
# Globals: SAVED_PORT_FILE
########################################
select_port()
{
	echo -n "Select port: "
	read PORT
	echo $PORT > $SAVED_PORT_FILE
}

########################################
# Ask for FreeBSD versions to test
# Input: None
# Output: None
# Globals: None
########################################
select_versions()
{
	local all_versions=$(print_versions)
	echo >&2
	echo "${all_versions}" >&2
	echo -n "Select versions (default All): " >&2
	read user_selected_versions

	if [[ -z $user_selected_versions ]];then
		user_selected_versions="$all_versions"
	fi

	echo "$user_selected_versions"
}

########################################
# Ask for architectures to test
# Input: None
# Output: None
# Globals: None
########################################
select_archs()
{
	local all_archs=$(print_archs)
	echo >&2
	echo "${all_archs}" >&2
	echo -n "Select architectures (default All): " >&2
	read user_selected_archs

	if [[ -z $user_selected_archs ]];then
		user_selected_archs="$all_archs"
	fi
	
	echo "$user_selected_archs"
}

####################
# Main entry point #
####################

if [[ $UID -ne 0 ]];then
	echo You need to be root.
	exit 0
fi

cleanup

select_port

SELECTED_VERSIONS=$(select_versions)

SELECTED_ARCHS=$(select_archs)

echo
echo -n "Select max concurrency: "
read MAX_PROCS

save_selected_jails "$SELECTED_VERSIONS" "$SELECTED_ARCHS"

# Stream workers through xargs
cat $SAVED_JAILS_FILE | xargs -n1 -P$MAX_PROCS ./build_worker.sh 

cleanup
