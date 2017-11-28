#!/usr/local/bin/bash

source config.sh

get_canonical_port_name()
{
	local port_name=$(basename ${1})
	local port_version=$(make -C ${PORTS_BASE}/${1} -V PORTVERSION)
	echo "${port_name}-${port_version}"
}
