#!/usr/bin/env bash
set -euo pipefail

mkdir -p /var/bmstu-stats
cd /var/bmstu-stats

wget --output-document=./01.03.02.pdf --append-output=./wget.log \
    https://priem.bmstu.ru/lists/upload/enrollees/first/moscow-1/01.03.02.pdf

pdftotext -layout -nopgbrk ./01.03.02.pdf # TODO сделать лог pdftotext

places=$(grep "1. Поступающие на места в рамках КЦП по общему конкурсу" \
    01.03.02.txt | sed 's/.* \([0-9]*\) мест.*/\1/')

current=$(tail \
    +$(sed -n '/1. Поступающие на места в рамках КЦП по общему конкурсу/=' \
    01.03.02.txt) 01.03.02.txt | \
    sed '/183-084-710 72/Q' | awk '{print $12}' | grep -c "Да") || true
current=$((current + 1))

echo "$current/$places"
