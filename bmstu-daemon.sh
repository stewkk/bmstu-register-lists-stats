#!/usr/bin/env bash
set -euo pipefail

##############################################################################
# демон проверяет место Гоши в конкурсных списках и при изменении отправляет #
# сообщение в телеграм                                                       #
##############################################################################

log() {
    echo $(date) "bmstu-daemon: ""$1" >> bmstu-daemon.log
}

start_daemon() {
    umask 0

    mkdir -p /var/bmstu-stats
    cd /var/bmstu-stats

    log "daemon started"

    exec 0<&-
    exec 1<&-
    exec 2<&-

    # init
    test -f state.txt || bmstu-iu9 > state.txt

    while true; do
        log "updating lists"
        cp state.txt state_old.txt
        bmstu-iu9 > state.txt
        diff -q state.txt state_old.txt || true # TODO отправлять сообщение
        sleep 30
    done
}

start_daemon &
sleep infinity
