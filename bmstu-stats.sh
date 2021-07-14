#!/usr/bin/env bash
set -euo pipefail

if [ ${1+x} ]; then
    spec="$1"
else
    spec="01.03.02"
fi

ascii_name=$(cat << "EOF"
 ____  __  __ ____ _____ _   _   ____ _____  _  _____ ____
| __ )|  \/  / ___|_   _| | | | / ___|_   _|/ \|_   _/ ___|
|  _ \| |\/| \___ \ | | | | | | \___ \ | | / _ \ | | \___ \
| |_) | |  | |___) || | | |_| |  ___) || |/ ___ \| |  ___) |
|____/|_|  |_|____/ |_|  \___/  |____/ |_/_/   \_\_| |____/
EOF
)
echo "$ascii_name"

# скачать списки зарегистрированных
tmp_dir="/tmp/bmstu_stats"
mkdir -p $tmp_dir
wget -nv \
-P $tmp_dir/ \
https://priem.bmstu.ru/lists/upload/registered/registered-first-Moscow.pdf

# # преобразовать pdf в txt
pdftotext -layout $tmp_dir/registered-first-Moscow.pdf
rm $tmp_dir/registered-first-Moscow.pdf

# получить статистику по направлению
applicants_filtered=$(grep $spec < $tmp_dir/registered-first-Moscow.txt)
total=$(echo "$applicants_filtered" | wc -l)
applicants_filtered=$(echo "$applicants_filtered" | \
    sed "s/.*$spec//" | awk '{print $1, $2}')
bvi=$(echo "$applicants_filtered" | grep -c "БВИ")
quota=$(echo "$applicants_filtered" | grep -c "10%")
paid=$(echo "$applicants_filtered" | grep -c "да")
only_paid=$(echo "$applicants_filtered" | awk '{print $1}' | grep -c "да")
targeted=$(echo "$applicants_filtered" | grep -c "ЦП")
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
targeted=$(("$targeted" < "$places_targeted" ? "$targeted" : "$places_targeted"))
quota=$(("$quota" < "$places_quota" ? "$quota" : "$places_quota"))
echo "мест для ОК:" $(("$places_total" - "$places_quota" - "$bvi" - "$places_targeted"))" - "$(("$places_total" - "$places_quota" - "$bvi" - "$targeted"))
