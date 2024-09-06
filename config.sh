# Exit if uninitialized variable used
set -u

# Temporal file names
SAVED_JAILS_FILE=saved_jails
SAVED_PORT_FILE=saved_port_name
TG_CHATID_FILE=~/.telegram/chatid
TG_KEY_FILE=~/.telegram/key
DB_OAUTH_FILE=~/.portbuilder_dropbox/oauth_token
PORTS_COLLECTION=default
PORTS_BASE=/usr/local/poudriere/ports/${PORTS_COLLECTION}/
LOGS_BASE=/usr/local/poudriere/data/logs/bulk/latest-per-pkg/

#TERMINAL_CMD="terminology --exec "
TERMINAL_CMD="xterm -e "
CURL_BIN="$(whereis -q curl | cut -f1 -d' ')"

C_RED="\e[31m"
C_GREEN="\e[32m"
C_RESTORE="\e[0m"

FAIL_STR=$(printf "FAILED \u26D4")
SUCCESS_STR=$(printf "OK \u2705")
