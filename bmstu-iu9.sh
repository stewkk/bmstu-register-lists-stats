#!/usr/bin/env bash
set -euo pipefail

cd /var/bmstu-stats

wget -q \
    https://priem.bmstu.ru/lists/upload/enrollees/first/moscow-1/01.03.02.pdf

pdftotext -layout -nopgbrk ./01.03.02.pdf
rm -f ./01.03.02.pdf || true

places=$(sed 's/^.*\([0-9]\+\) мест.*$/\1/' < 01.03.02.txt)
