#!/usr/bin/env bash
set -euo pipefail

spec="01.03.02"

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
tmp_dir="/tmp/bmstu_stats/"
mkdir -p $tmp_dir
wget -nv \
-P $tmp_dir \
https://priem.bmstu.ru/lists/upload/registered/registered-first-Moscow.pdf

# преобразовать pdf в txt
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

# вывод статистики
echo "всего:" "$total"
echo "БВИ:" "$bvi"
echo "10%:" "$quota"
echo "все, у кого согласие на платку:" "$paid"
echo "только платка:" "$only_paid"
echo "целевое:" "$targeted"
echo "мест для ОК:" $((34 - 4 - "$bvi" - 8))"-"$((34 - 4 - "$bvi" - "$targeted"))
