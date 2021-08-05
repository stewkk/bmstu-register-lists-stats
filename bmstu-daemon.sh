#!/usr/bin/env bash
set -euo pipefail

##############################################################################
# демон проверяет место Гоши в конкурсных списках и при изменении отправляет #
# сообщение в телеграм                                                       #
##############################################################################

pid=fork
[ "$pid" = -1 ] && exit 1

[ "$pid" -gt 0 ] && exit 0

umask 0

# TODO открыть логи для записи

sid=setsid
[ "$sid" -lt 0 ] && exit 1

mkdir -p /var/bmstu-stats
cd /var/bmstu-stats

exec 0<&-
exec 1<&-
exec 2<&-

# init
test -f state.txt || bmstu-iu9 > state.txt

while true; do
    cp state.txt state_old.txt
    bmstu-iu9 > state.txt
    diff -q state.txt state_old.txt || true # TODO отправлять сообщение
    sleep 30
done
