#!/usr/bin/env bash
set -euo pipefail

min() {
    (( $1 <= $2 )) && echo "$1" || echo "$2"
}

cd "$(dirname "$BASH_SOURCE")"

ascii_name=$(cat << "EOF"
 ____  __  __ ____ _____ _   _   ____ _____  _  _____ ____
| __ )|  \/  / ___|_   _| | | | / ___|_   _|/ \|_   _/ ___|
|  _ \| |\/| \___ \ | | | | | | \___ \ | | / _ \ | | \___ \
| |_) | |  | |___) || | | |_| |  ___) || |/ ___ \| |  ___) |
|____/|_|  |_|____/ |_|  \___/  |____/ |_/_/   \_\_| |____/
EOF
)

is_quiet=""

if [ ${2+x} ]; then
    spec="$2"
    is_quiet="$1"
elif [ ${1+x} ]; then
    spec="$1"
else
    spec="01.03.02"
fi

if [ "$is_quiet" != "-q" ]; then
    echo "$ascii_name"
fi
echo "$spec"
date

# скачать списки зарегистрированных
tmp_dir="/tmp/bmstu_stats"
mkdir -p $tmp_dir
rm -f $tmp_dir/registered-first-Moscow.pdf || true
wget -q \
-P $tmp_dir/ \
https://priem.bmstu.ru/lists/upload/registered/registered-first-Moscow.pdf

# преобразовать pdf в txt
pdftotext -layout $tmp_dir/registered-first-Moscow.pdf
rm -f $tmp_dir/registered-first-Moscow.pdf || true

# получить статистику по направлению
applicants_filtered=$(grep $spec < $tmp_dir/registered-first-Moscow.txt)
total=$(echo "$applicants_filtered" | wc -l)
applicants_filtered=$(echo "$applicants_filtered" | \
    sed "s/.*$spec//" | awk '{print $1, $2}')
bvi=$(echo "$applicants_filtered" | grep -c "БВИ" || true)
quota=$(echo "$applicants_filtered" | grep -c "10%" || true)
paid=$(echo "$applicants_filtered" | grep -c "да" || true)
only_paid=$(echo "$applicants_filtered" | awk '{print $1}'\
    | grep -c "да" || true)
targeted=$(echo "$applicants_filtered" | grep -c "ЦП" || true)
places_total=$(grep "$spec" "./places_list.txt" | awk '{print $3}')
places_quota=$(grep "$spec" "./places_list.txt" | awk '{print $4}')
places_targeted=$(grep "$spec" "./places_list.txt" | awk '{print $5}')

# вывод статистики
echo "всего:" "$total"
echo "БВИ:" "$bvi"
echo "10%:" "$quota"
echo "все, у кого согласие на платку:" "$paid"
echo "только платка:" "$only_paid"
echo "целевое:" "$targeted"
targeted=$(min "$targeted" "$places_targeted")
quota=$(min "$quota" "$places_quota")
ok=("мест для ОК: "
    $(("$places_total" - "$places_quota" - "$bvi" - "$places_targeted"))
    " - "
    $(("$places_total" - "$places_quota" - "$bvi" - "$targeted")))
printf "%s" "${ok[@]}"
echo ""
if [ "$spec" = "01.03.02" ]; then
    ok_32=$(bc <<< "$places_total - $places_quota - (\
        $bvi * 0.68) - $targeted")
    printf "%s%0.f\n" "ОК, если 32% БВИ не подадут согласие: " "$ok_32"
fi
