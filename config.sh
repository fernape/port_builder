# Exit if uninitialized variable used
set -u

# Temporal file names
SAVED_JAILS_FILE=saved_jails
SAVED_PORT_FILE=saved_port_name
TG_CHATID_FILE=~/.telegram/chatid
TG_KEY_FILE=~/.telegram/key

#TERMINAL_CMD="terminology --exec "
TERMINAL_CMD="xterm -e "

C_RED="\e[31m"
C_GREEN="\e[32m"
C_RESTORE="\e[0m"
