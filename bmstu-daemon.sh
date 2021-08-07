#!/usr/bin/env bash
set -euo pipefail

##############################################################################
# демон проверяет место Гоши в конкурсных списках и при изменении отправляет #
# сообщение в телеграм                                                       #
##############################################################################

log() {
    echo $(date) "bmstu-daemon: ""$1" >> bmstu-daemon.log
}

send_message() {
    state=$(cat state.txt)
    token=$(cat token)
    chat_id=$(cat chat_id)
    curl -v "https://api.telegram.org/bot""$token""/sendMessage?chat_id="\
"$chat_id""&text=""$state" >> api.log
}

start_daemon() {
    umask 0

    mkdir -p /var/bmstu-stats
    cd /var/bmstu-stats

    log "daemon started"

    # init
    if [ ! -f state.txt ]; then
        log "state.txt not found, updating lists"
        bmstu-iu9 > state.txt
        send_message
    elif ! grep -m 1 '^[0-9]\+\/[0-9]\+$' state.txt; then
        log "state.txt is invalid, updating lists"
        bmstu-iu9 > state.txt
        send_message
    fi

    while true; do
        log "updating lists"
        cp state.txt state_old.txt
        bmstu-iu9 > state.txt
        if ! cmp state.txt state_old.txt; then
            log "state changed"
            send_message
        fi
        sleep 30
    done
}

start_daemon
