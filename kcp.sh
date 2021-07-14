#!/usr/bin/env bash
set -euo pipefail

specs_list=$(cat ./kcp.txt)

specs_filtered=$(echo "$specs_list" | sed '/ГУИМЦ/d' | grep '..\...\...' \
    | sed 's/^.*\(..\...\... \+\(бакалавр\|специалист\) \+[0-9]\+ \+[0-9]\+ \+[0-9]\+\).*$/\1/')
echo "$specs_filtered" > places_list.txt
