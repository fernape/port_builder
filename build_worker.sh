#!/usr/local/bin/bash

source config.sh

JAIL_NAME=$1
PORT_NAME=$(cat $SAVED_PORT_FILE)

$($TERMINAL_CMD"poudriere testport -p default -j $JAIL_NAME -o $PORT_NAME")
