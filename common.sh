#!/usr/local/bin/bash

source config.sh

get_canonical_port_name()
{
	local port_name=$(basename ${1})
	local port_version=$(make -C ${PORTS_BASE}/${1} -V PORTVERSION)
	local port_revision=$(make -C ${PORTS_BASE}/${1} -V PORTREVISION)

	local extra_suffix=""
	if [[ ! -z "${port_revision}" && "${port_revision}" != "0" ]]; then
		extra_suffix="_${port_revision}"
	fi

	echo "${port_name}-${port_version}${extra_suffix}"
}
